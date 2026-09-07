---
type: Release Policy
title: Acceptance gates and evidence ownership
description: Distinct checks for internal builds, reviewed learning, supervised pilots, and future release.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Gates are not interchangeable

| Gate | Required evidence | Accountable role | Blocking effect |
|---|---|---|---|
| A — Internal engineering | GDM-001–026; synthetic profiles; permitted fixtures; restricted environment; web/APK parity | Engineering + QA | Blocks “internal MVP complete,” not early local development |
| B — Real learning assets | GDM-027; immutable pack hash; rights scope; Arabic/font/audio approval | Content rights owner + curriculum reviewer | Blocks reviewed-learning mode with missing evidence |
| C — Participant authorization | GDM-028; approved protocol, privacy decisions and consent process; no invented legal sufficiency | Privacy/pilot owner | Blocks recruitment and real participant data |
| D — Pilot observations | GDM-029; actually run sessions with approved protocol | Human pilot facilitator | Blocks claims about user usability |
| E — Remediation | GDM-030; issue-by-issue findings disposition and regression evidence | Engineering + QA | Blocks unresolved pilot acceptance |
| F — Operational preflight | GDM-031; candidate/environment-specific execution after B–E | Release operator | Blocks acceptance of that pilot candidate |
| G — Owner acceptance | GDM-032; actual owner decisions tied to candidate/evidence | Product + content + privacy + release owners | Blocks declaring supervised pilot accepted |

All evidence is initially **absent**, not pending approval by an invented person. Roles identify who must act; no signatures, names, dates of approval, participant counts, or successful results are prefilled.

## Environment separation

Local and internal staging permit only synthetic profiles under this new client until authorization changes. Staging pairing endpoints require an environment allowlist, server-configured staging audience, and authorized parent account. Production must return a neutral unavailable response for this flow and reject its credentials. A debug APK cannot create production grants by editing its API URL.

GDM-025 implements the evaluator and safe rollback. GDM-026 runs internal checks. Neither replaces GDM-031 or GDM-032. A “missing approval rejected” test is proof of a control, not proof of approval.

## Human-blocked work

GDM-027/028/032 require actual external decisions. GDM-029 requires actual observed sessions. GDM-030 is engineering/QA blocked on observations; it is not a human-only approval. GDM-031 is operational execution blocked on prerequisite evidence. Keep these statuses and owners distinct.

## Public access stays excluded

Passing the supervised-pilot track does not authorize public web exposure, production native credentials, stores, or scaling to new jurisdictions. Those require a separately scoped release decision and contemporary review. These are project requirements, not a legal opinion on any specific jurisdiction.
