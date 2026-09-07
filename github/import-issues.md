---
type: Runbook
title: Dry-run-first GitHub issue importer
description: A create-only standard-library helper embedded as Markdown for authorized registration.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: gh-api
  resource: https://cli.github.com/manual/gh_api
  title: GitHub CLI — gh api
- id: gh-issue
  resource: https://cli.github.com/manual/gh_issue_create
  title: GitHub CLI — gh issue create
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Importer behavior

Requirements: Python 3.10+ standard library; GitHub CLI `gh` authenticated with permissions to create issues/labels/milestones in the target repository. `--apply` performs writes; without it the helper is strictly local and makes no network call. CLI pagination is used for existing records.[^gh-api]

The helper validates issue hashes and dependency order, checks the exact Markdown bundle exists at the chosen committed ref, finds all open/closed issue markers, then creates missing labels/milestones/issues. Source links use an immutable SHA. Prerequisites become actual issue links. It never edits/closes/reopens/assigns existing issues or changes current label definitions.

Run only one importer for this namespace at a time. Marker checks provide rerun safety, not an atomic cross-process uniqueness guarantee. A failed mutation is not automatically retried; rerun to discover whether it succeeded. An unmarked existing `[GDM-...]` issue or duplicate marker stops the import for manual reconciliation.

`--only` includes transitive dependencies automatically. Default is all 32 issues. `--ref` defaults to repository HEAD; pass a specific documentation commit when appropriate. The exact bundle must be committed under `--docs-path`; keep temporary receipts/scripts outside it to avoid source-tree mismatch.

See [registration steps](README.md) before extracting/running this code. It is tested locally with a fake API, not against the user's GitHub repository. Local tests and limits are listed in [package validation](../qa/package-validation.md).

<!-- BEGIN_IMPORTER -->
```python
#!/usr/bin/env python3
"""Create-only GitHub issue importer for the Markdown OKF bundle.

Default mode is a local, no-network plan. --apply authorizes writes.
Uses Python 3.10+ standard library and authenticated GitHub CLI only.
"""
from __future__ import annotations
import argparse
import hashlib
import json
import posixpath
import re
import shutil
import subprocess
import sys
from pathlib import Path
from urllib.parse import quote

MARKER = re.compile(r"<!-- rzq-godot-mvp:(GDM-\d{3}) -->")
TITLE_ID = re.compile(r"^\[(GDM-\d{3})\]")
LINK = re.compile(r"(?<!!)\[([^\]\n]*)\]\(([^\s)]+)\)")


def fail(message: str) -> None:
    raise RuntimeError(message)


def under(root: Path, relative: str) -> Path:
    p = (root / relative).resolve()
    if not p.is_relative_to(root) or not p.is_file():
        fail(f"Missing or unsafe bundle file: {relative}")
    return p


def load_manifest(root: Path) -> dict:
    text = under(root, "github/manifest.md").read_text(encoding="utf-8")
    match = re.search(r"<!-- BEGIN_MANIFEST -->\s*```json\n(.*?)\n```", text, re.S)
    if not match:
        fail("The canonical JSON manifest fence was not found.")
    data = json.loads(match.group(1))
    if data.get("schema_version") != 1:
        fail("Unsupported import manifest version.")
    ids = [x["id"] for x in data["issues"]]
    if len(ids) != len(set(ids)):
        fail("Duplicate issue IDs in manifest.")
    for item in data["issues"]:
        raw = under(root, item["file"]).read_bytes()
        if hashlib.sha256(raw).hexdigest() != item["sha256"]:
            fail(f"File hash differs from manifest: {item['file']}")
        if MARKER.findall(raw.decode("utf-8")) != [item["id"]]:
            fail(f"Issue marker missing, duplicated or mismatched: {item['id']}")
        if any(dep not in ids for dep in item["depends_on"]):
            fail(f"Unknown dependency in {item['id']}")
    return data


def ordered(items: list[dict], requested: list[str] | None) -> list[dict]:
    by_id = {x["id"]: x for x in items}
    requested = requested or list(by_id)
    if set(requested) - set(by_id):
        fail("Unknown --only ID: " + ", ".join(sorted(set(requested) - set(by_id))))
    active: set[str] = set()
    done: set[str] = set()
    out: list[dict] = []

    def visit(key: str) -> None:
        if key in active:
            fail(f"Dependency cycle at {key}")
        if key in done:
            return
        active.add(key)
        for dep in by_id[key]["depends_on"]:
            visit(dep)
        active.remove(key)
        done.add(key)
        out.append(by_id[key])

    for key in requested:
        visit(key)
    return out


def gh_api(method: str, endpoint: str, payload: dict | None = None,
           pages: bool = False):
    cmd = ["gh", "api", "--hostname", "github.com", "--method", method,
           endpoint, "-H", "Accept: application/vnd.github+json"]
    if pages:
        cmd += ["--paginate", "--slurp"]
    data = None
    if payload is not None:
        cmd += ["--input", "-"]
        data = json.dumps(payload, ensure_ascii=False)
    result = subprocess.run(cmd, input=data, text=True, capture_output=True,
                            timeout=90, check=False)
    if result.returncode:
        # No automatic retry of mutations: a lost response can conceal success.
        fail(f"gh api {method} {endpoint} failed (exit {result.returncode}). "
             "Inspect access/state, then rerun. Mutations are not retried automatically.\n"
             + result.stderr[-1200:])
    return json.loads(result.stdout) if result.stdout.strip() else None


def all_pages(endpoint: str) -> list[dict]:
    pages = gh_api("GET", endpoint, pages=True)
    if not isinstance(pages, list) or any(not isinstance(p, list) for p in pages):
        fail("Unexpected paginated GitHub response shape.")
    return [item for page in pages for item in page]


def git_blob_sha(raw: bytes) -> str:
    return hashlib.sha1(b"blob " + str(len(raw)).encode() + b"\0" + raw).hexdigest()


def verify_remote_bundle(root: Path, repo: str, docs_path: str, ref: str) -> str:
    commit = gh_api("GET", f"repos/{repo}/commits/{quote(ref, safe='')}")
    sha = commit["sha"]
    tree_sha = commit["commit"]["tree"]["sha"]
    for part in docs_path.split("/"):
        tree = gh_api("GET", f"repos/{repo}/git/trees/{tree_sha}")
        if tree.get("truncated"):
            fail("Git tree truncated; choose a smaller dedicated documentation path.")
        found = [n for n in tree["tree"] if n["path"] == part and n["type"] == "tree"]
        if len(found) != 1:
            fail(f"Committed documentation directory missing: {docs_path}")
        tree_sha = found[0]["sha"]
    tree = gh_api("GET", f"repos/{repo}/git/trees/{tree_sha}?recursive=1")
    if tree.get("truncated"):
        fail("Documentation tree truncated; cannot verify immutable source links.")
    blobs = {n["path"]: n["sha"] for n in tree["tree"] if n["type"] == "blob"}
    for file in sorted(root.rglob("*.md")):
        rel = file.relative_to(root).as_posix()
        if blobs.get(rel) != git_blob_sha(file.read_bytes()):
            fail(f"Local/committed document mismatch: {rel}. "
                 "Commit this exact bundle and pass the correct --ref first.")
    return sha


def existing_issue_map(repo: str, known: set[str]) -> dict[str, dict]:
    mapped: dict[str, dict] = {}
    for item in all_pages(f"repos/{repo}/issues?state=all&per_page=100"):
        if "pull_request" in item:
            continue
        markers = MARKER.findall(item.get("body") or "")
        title_match = TITLE_ID.match(item.get("title") or "")
        if title_match and title_match.group(1) in known and not markers:
            fail(f"Unmarked existing issue #{item['number']} uses {title_match.group(1)}. "
                 "Reconcile it manually instead of creating a duplicate.")
        matching = [m for m in markers if m in known]
        if len(matching) > 1:
            fail(f"Multiple known markers on issue #{item['number']}.")
        for key in matching:
            if key in mapped:
                fail(f"Duplicate remote marker {key}; reconcile before importing.")
            if title_match and title_match.group(1) != key:
                fail(f"Marker/title ID conflict on issue #{item['number']}.")
            mapped[key] = item
    return mapped


def render_body(root: Path, item: dict, repo: str, docs_path: str,
                sha: str, known_urls: dict[str, str]) -> str:
    raw = under(root, item["file"]).read_text(encoding="utf-8")
    if not raw.startswith("---\n"):
        fail(f"Missing OKF frontmatter: {item['file']}")
    end = raw.find("\n---\n", 4)
    if end < 0:
        fail(f"Unclosed OKF frontmatter: {item['file']}")
    body = raw[end + len("\n---\n"):].lstrip()
    base = f"https://github.com/{repo}/blob/{sha}/{quote(docs_path, safe='/')}"

    def replace(match: re.Match) -> str:
        label, url = match.groups()
        if re.match(r"^[a-zA-Z][a-zA-Z0-9+.-]*:", url) or url.startswith("#"):
            return match.group(0)
        target, sep, fragment = url.partition("#")
        normalized = posixpath.normpath(
            target.lstrip("/") if target.startswith("/") else
            posixpath.join(posixpath.dirname(item["file"]), target))
        if normalized == ".." or normalized.startswith("../"):
            fail(f"Link escapes bundle in {item['id']}: {url}")
        under(root, normalized)
        dependency = re.fullmatch(r"github/issues/(GDM-\d{3})\.md", normalized)
        if dependency and dependency.group(1) in known_urls:
            new_url = known_urls[dependency.group(1)]
        else:
            new_url = base + "/" + quote(normalized, safe="/")
        if sep:
            new_url += "#" + fragment
        return f"[{label}]({new_url})"

    body = LINK.sub(replace, body)
    source = base + "/" + quote(item["file"], safe="/")
    return body.rstrip() + ("\n\n---\nOriginal criteria snapshot: "
                            f"[OKF issue document]({source}).\n"
                            "Registration does not mark implementation or approval complete.\n")


def main(argv: list[str] | None = None) -> int:
    p = argparse.ArgumentParser(description=__doc__)
    p.add_argument("--bundle", required=True, type=Path)
    p.add_argument("--repo", required=True, help="Explicit OWNER/REPO; github.com only")
    p.add_argument("--docs-path", default="docs/godot-mvp")
    p.add_argument("--ref", default="HEAD", help="Committed branch/tag/SHA; resolved to immutable SHA")
    p.add_argument("--only", nargs="+", help="Selected GDM IDs; transitive prerequisites included")
    p.add_argument("--apply", action="store_true", help="Authorize GitHub writes")
    args = p.parse_args(argv)
    root = args.bundle.resolve()
    if not root.is_dir():
        fail("Bundle directory not found.")
    if not re.fullmatch(r"[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+", args.repo):
        fail("Use --repo OWNER/REPO, not a URL.")
    if (not re.fullmatch(r"[A-Za-z0-9_.-]+(?:/[A-Za-z0-9_.-]+)*", args.docs_path)
            or any(x in (".", "..") for x in args.docs_path.split("/"))):
        fail("Use a safe repository-relative --docs-path, e.g. docs/godot-mvp.")
    manifest = load_manifest(root)
    selected = ordered(manifest["issues"], args.only)
    if not args.apply:
        print("# Local issue import plan — NO NETWORK, NO WRITES\n")
        print(f"Target: `{args.repo}`; documents: `{args.docs_path}`; ref: `{args.ref}`.\n")
        print("Remote state has not been checked. Existing marked issues will be skipped on apply.\n")
        print("| Issue | Milestone | Prerequisites |\n|---|---|---|")
        for item in selected:
            print(f"| {item['id']} | {item['milestone']} | {', '.join(item['depends_on']) or 'None'} |")
        print(f"\n{len(selected)} planned issues. Pass --apply only after review and authorization.")
        return 0
    if shutil.which("gh") is None:
        fail("GitHub CLI (gh) is required for --apply.")
    repo = gh_api("GET", f"repos/{args.repo}")
    if not repo.get("has_issues", False):
        fail("Issues are disabled for this repository.")
    sha = verify_remote_bundle(root, args.repo, args.docs_path, args.ref)
    existing = existing_issue_map(args.repo, {x['id'] for x in manifest['issues']})
    labels = {x['name'] for x in all_pages(f"repos/{args.repo}/labels?per_page=100")}
    needed_labels = {name for x in selected for name in x['labels']}
    for label in manifest["labels"]:
        if label["name"] in needed_labels and label["name"] not in labels:
            gh_api("POST", f"repos/{args.repo}/labels", label)
            labels.add(label["name"])
    milestone_ids: dict[str, int] = {}
    for item in all_pages(f"repos/{args.repo}/milestones?state=all&per_page=100"):
        if item["title"] in milestone_ids:
            fail(f"Duplicate milestone title: {item['title']}")
        milestone_ids[item["title"]] = item["number"]
    needed_milestones = {x['milestone'] for x in selected}
    for milestone in manifest["milestones"]:
        title = milestone["title"]
        if title in needed_milestones and title not in milestone_ids:
            result = gh_api("POST", f"repos/{args.repo}/milestones",
                            {"title": title, "description": milestone["description"]})
            milestone_ids[title] = result["number"]
    urls = {key: value['html_url'] for key, value in existing.items()}
    print("# GitHub issue import receipt\n")
    print(f"Repository: `{args.repo}`. Criteria commit: `{sha}`.\n")
    print("| Issue | Action | GitHub issue |\n|---|---|---|", flush=True)
    for item in selected:
        key = item["id"]
        if key in existing:
            print(f"| {key} | SKIPPED — preserved existing state/body | {urls[key]} |", flush=True)
            continue
        missing = [dep for dep in item["depends_on"] if dep not in urls]
        if missing:
            fail(f"Prerequisite registration missing for {key}: {missing}")
        body = render_body(root, item, args.repo, args.docs_path, sha, urls)
        payload = {"title": item["title"], "body": body, "labels": item["labels"],
                   "milestone": milestone_ids[item["milestone"]]}
        created = gh_api("POST", f"repos/{args.repo}/issues", payload)
        urls[key] = created["html_url"]
        print(f"| {key} | CREATED — open | {urls[key]} |", flush=True)
    print("\nNo existing issue was edited, closed, reopened, or assigned. "
          "Dependencies are linked in bodies; native GitHub dependency relationships were not created.")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except (RuntimeError, OSError, ValueError, KeyError, subprocess.TimeoutExpired) as exc:
        print(f"ERROR: {exc}", file=sys.stderr)
        raise SystemExit(1)

```
<!-- END_IMPORTER -->

[^gh-api]: GitHub CLI — gh api.
