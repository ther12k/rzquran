---
type: Runbook
title: Register the MVP issues on GitHub
description: Manual or dry-run-first automated registration without implied authorization.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: gh-issue
  resource: https://cli.github.com/manual/gh_issue_create
  title: GitHub CLI — gh issue create
- id: gh-api
  resource: https://cli.github.com/manual/gh_api
  title: GitHub CLI — gh api
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# GitHub registration

The ZIP contains issue-ready Markdown, not already-created GitHub issues. No repository changes are made by opening/extracting it. The proposed target is the user-named `ther12k/rz-quran`; replace it if your repository differs.

## Recommended: commit the complete bundle, then import

Place the **contents** of this bundle in your repository under `docs/godot-mvp/`, keeping `README.md`, `AGENTS.md`, the directory indexes and all other Markdown in that subdirectory. Do not overwrite your repository-root `AGENTS.md`. Review and commit these documents through your normal workflow before importing. The helper resolves a chosen branch/tag/SHA and checks that every local Markdown byte matches the committed bundle.

Extract the one Python code block to a temporary path outside the bundle. From the repository root, run:

```sh
python3 - <<'PY'
from pathlib import Path
text = Path('docs/godot-mvp/github/import-issues.md').read_text(encoding='utf-8')
start = '<!-- BEGIN_IMPORTER -->\n```python\n'
code = text.split(start, 1)[1].split('\n```\n<!-- END_IMPORTER -->', 1)[0]
Path('/tmp/rzq_import_issues.py').write_text(code + '\n', encoding='utf-8')
print('Wrote /tmp/rzq_import_issues.py; review before running.')
PY

# Local plan: no GitHub access or writes.
python3 /tmp/rzq_import_issues.py \
  --bundle docs/godot-mvp \
  --repo ther12k/rz-quran \
  --docs-path docs/godot-mvp \
  --ref HEAD
```

On Windows, replace `/tmp/` with a local temporary directory and run the same Python extraction through your shell/editor. Do not place the extracted `.py` inside the Markdown bundle.

After reviewing the plan and explicitly deciding to register the issues, authenticate with GitHub CLI, then run:

```sh
gh auth status
python3 /tmp/rzq_import_issues.py \
  --bundle docs/godot-mvp \
  --repo ther12k/rz-quran \
  --docs-path docs/godot-mvp \
  --ref HEAD \
  --apply > /tmp/rzq-github-import-receipt.md
```

This authorizes creation of missing labels, milestones and up to **32 open issues**. To register only the internal-MVP prerequisite closure, add `--only GDM-026`; that selects GDM-001–026 via dependencies and excludes the six pilot issues. To start with foundations only, use `--only GDM-005 GDM-002`. Existing marked issues are skipped, including closed ones; registration never declares acceptance.

A failed run may have completed earlier mutations. Preserve its receipt and rerun after checking the error. The marker `<!-- rzq-godot-mvp:GDM-001 -->` is the stable deduplication key. Do not delete it or run concurrent importers. Existing issue-body changes are preserved deliberately, so later documentation edits need manual reconciliation rather than silent overwrite.

## Manual alternative

Open [issue index](issues/index.md), create an issue with the exact title, and copy its Markdown body **after** the closing YAML frontmatter delimiter. Preserve the marker, checklist and evidence sections. Apply the labels/milestone from its metadata. Update dependency IDs to the real issue links after registration.

GitHub CLI also accepts `--title` and `--body-file` when creating an issue.[^gh-issue] A body file for this command should omit frontmatter and use repository/issue links; the automated helper performs that transformation for you.

## What is not automated

No native dependency relationships, Projects board, sub-issues, assignee guesses, owner approvals, due dates, closures or code pushes. The helper uses github.com only; enterprise-host customization is not implemented. Authorized repository users remain responsible for all writes and for linking actual acceptance evidence.

[^gh-issue]: GitHub CLI — gh issue create.
