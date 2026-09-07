---
type: Format Profile
title: OKF v0.2 profile for this MVP bundle
description: Standard OKF fields, local extensions, and mechanical-validation scope.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: okf
  resource: https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md
  title: Google Cloud Platform — OKF specification v0.2
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Format profile

Target: **Google Cloud Platform Open Knowledge Format v0.2**, not a proprietary `.okf` binary. Its specification uses Markdown concepts with YAML frontmatter and permits producer extensions.[^okf]

Root `index.md` declares `okf_version: "0.2"`. Other directory indexes contain no frontmatter. `log.md` contains date-grouped history. Every other Markdown file has a nonempty `type`, title/description, tags, draft lifecycle, generated actor/time, and relevant sources. Concept IDs are paths without `.md`.

Internal links use relative paths for convenient browsing when this bundle is committed under `docs/godot-mvp`. Root-relative paths in `sources` refer to this bundle, not the GitHub repository root. External source facts use named footnotes matching `sources[].id`. No `verified` human actor is invented.

## Project extensions — not OKF standard fields

| `x_rzq` key | Meaning |
|---|---|
| `bundle_version` | Version of this handoff |
| `review_state` | Document review status, initially unreviewed |
| `language` / `ui_language` | English documentation / Indonesian interface |
| `issue_id` | Stable GDM task identifier, independent of GitHub issue number |
| `issue_state` | Planning state; not synchronized automatically to GitHub |
| `github_title`, `milestone`, `labels` | Registration metadata |
| `kind`, `track`, `owner_role`, `estimate` | Planning distinctions |
| `requirements`, `depends_on` | Traceability and dependency IDs; body links also express relationships |

`type: GitHub Issue`, `API Contract`, and other names are local descriptive types. `status: draft` is documentation lifecycle; it does not mean an issue is closed/open or a release is approved. The importer reads the canonical fenced JSON in [manifest](../github/manifest.md), not an undocumented interpretation of all YAML fields.

## Validation boundaries

Package checks cover parseable frontmatter, reserved filenames, IDs/dependencies, source/footnote linkage, local targets, embedded JSON/schema examples, issue hashes, and ZIP integrity. A project-specific stricter broken-link or task-consistency check is not an additional universal OKF requirement. The bundle does not claim third-party certification, app runtime verification or human approval.

The generated field states authorship, not truth verification. A machine packaging check must not stamp the entire engineering/curriculum specification as human-reviewed. Keep substantive reviews separate from structural checks.

[^okf]: Google Cloud Platform — OKF specification v0.2.
