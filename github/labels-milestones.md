---
type: Planning Taxonomy
title: GitHub labels and milestones
description: Small task taxonomy that does not confuse engineering with human approvals.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: gh-label
  resource: https://cli.github.com/manual/gh_label_create
  title: GitHub CLI — gh label create
- id: gh-milestone
  resource: https://docs.github.com/en/rest/issues/milestones?apiVersion=2022-11-28
  title: GitHub REST — issue milestones
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Labels

| Label | Suggested hex color | Meaning |
|---|---|---|
| `area:godot-mvp` | `226544` | Shared Godot child-learning MVP |
| `kind:engineering` | `1D76DB` | Implementation or engineering hardening |
| `kind:verification` | `5319E7` | Actual execution and evidence, not tooling alone |
| `kind:human-gate` | `B60205` | Actual external owner or reviewer evidence required |
| `kind:pilot` | `D93F0B` | Supervised real-participant observation |
| `track:internal-mvp` | `0E8A16` | Required for internal synthetic-profile MVP |
| `track:supervised-pilot` | `FBCA04` | Separate conditionally authorized supervised pilot |
| `platform:shared` | `C5DEF5` | Shared client, services or multi-platform acceptance |
| `platform:web` | `BFDADC` | Browser host, HTML equivalent or parent web interface |
| `platform:android` | `C2E0C6` | Native Android internal debug client |
| `priority:p0` | `B60205` | Required for scoped internal MVP |
| `priority:p1` | `D93F0B` | Required only for authorized supervised pilot track |

# Milestones

| Key | Exact GitHub title | Scope |
|---|---|---|
| M0 | GDM M0 - Foundation and scope | Inspect baseline, pin a shared project, define safe contracts and fixtures. |
| M1 | GDM M1 - Authoritative integration | Reuse session/progress services; add bounded web/native adapters. |
| M2 | GDM M2 - One learning journey | Home, examples, three questions, result, accessible equivalent and parent summary. |
| M3 | GDM M3 - Internal MVP verification | Web and Android artifacts, real-device checks, security and internal acceptance. |
| M4 | GDM M4 - Supervised pilot gates | Actual content/privacy evidence, observed pilot, remediation, operational preflight and owner acceptance; no public launch. |

The importer creates missing labels/milestones and preserves existing definitions. No deadline or assignee is invented. There is no `done` or blanket `external` label: closure/evidence is separate, and pilot remediation is engineering. Add a repository-specific blocked label manually only when the actual blocker is known.

Dependencies are recorded as `depends_on` IDs in documentation and converted to clickable issue links in imported bodies. The helper does not configure native GitHub dependency relationships, Projects boards, sub-issues, due dates or issue types. Those can be set by the repository owner using their chosen workflow.
