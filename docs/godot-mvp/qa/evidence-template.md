---
type: Evidence Template
title: Task and milestone evidence template
description: Empty evidence fields that distinguish implementation, execution and approval.
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

# Evidence template

Copy the relevant sections into the actual repository/issue. Nothing below is a completed result. Evidence involving real people or approvals belongs in authorized storage; reference it without publishing sensitive content in GitHub.

## Candidate

| Field | Value to fill |
|---|---|
| Task / milestone | Not recorded |
| Repository SHA and dirty state | Not recorded |
| Build ID / Godot+template versions | Not recorded |
| Content release/hash and mode | Not recorded |
| Web artifact + SHA-256 | Not recorded |
| Android APK + SHA-256 | Not recorded |
| Environment / target API audience | Not recorded |
| Executor and time | Not recorded |

## Implementation and tests

| Criterion / QA ID | Code or artifact reference | Exact command or manual procedure | Expected | Actual | Result |
|---|---|---|---|---|---|
| Not recorded | Not recorded | Not run | Not recorded | No result | NOT RUN |

Record tool exits, logs, sample sizes and failure details. For every screenshot note screen, viewport/device and build. For performance include raw runs, environment, cold/warm definitions, workload and error rates. Do not paste fake green output.

## Approval/observation evidence

| Gate | Required role | Actual evidence reference | Candidate/content scope | Decision/time |
|---|---|---|---|---|
| Content/rights | Content owner + reviewer | Absent | Not recorded | Not approved |
| Privacy/pilot | Authorized privacy/pilot owners | Absent | Not recorded | Not approved |
| Pilot observations | Human facilitator | Absent | Not recorded | Not run |
| Final pilot acceptance | Required owners | Absent | Not recorded | Not approved |

A GitHub comment by an implementation agent is not an external signature. Verify authenticity and scope without exposing participant details or confidential licenses.

## Acceptance summary

State implemented / tested / unexecuted / blocked / approved separately. List unresolved defects by severity, applied migrations, contract deviations and next dependency-ready tasks. For GDM-026 explicitly say whether only fixtures were tested. For GDM-031 list actual operational drill executions. For GDM-032 record the real human decision and excluded future uses.

## Closure checklist

- [ ] Original acceptance criteria remain intact or an explicit owner-approved change is linked.
- [ ] Required checks were executed; no unavailable device/test is relabeled as pass.
- [ ] Artifact and approval scope matches this candidate and content release.
- [ ] Security/content blockers are not waived silently.
- [ ] Public/store/native-iOS readiness is not implied by internal or pilot acceptance.
