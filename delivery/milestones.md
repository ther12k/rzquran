---
type: Delivery Plan
title: Milestones and dependency-ready execution
description: Incremental delivery without mixing implementation with external acceptance.
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

# Milestones

| Milestone | Issues | Deliverable | Exit |
|---|---|---|---|
| M0 | GDM-001–005 | Verified reuse map, shared shell exports, contracts and safe fixtures | Actual pins/exports; known security boundary; no approval fabricated |
| M1 | GDM-006–010 | Authoritative API/progress and bounded web/native adapters | Ownership, replay, staging audience and lifecycle tests |
| M2 | GDM-011–018 | One complete child lesson, HTML equivalent and parent summary | Full functional journey through real service responses |
| M3 | GDM-019–026 | Integrated web/Android artifacts and internal acceptance | Named device evidence, security/quality measurements, rollback executed |
| M4 | GDM-027–032 | Conditionally authorized supervised pilot | Actual approvals/observations/remediation/preflight/owner decision |

## Sequencing

Start GDM-001. Then GDM-002 and GDM-004 can progress in parallel. GDM-003 follows the security boundary; GDM-005 prepares honest fixtures; GDM-010 maps storage before stateful endpoints. The complete graph is in the [manifest](../github/manifest.md), [issue index](../github/issues/index.md), and [traceability](traceability.md).

Issue numbers do not imply strict sequential implementation. For example, GDM-010 is a prerequisite for GDM-006/007 despite its larger ID. Use `depends_on`, not numeric ordering. Registration order also does not mean work has been authorized or completed.

## Parallel ownership

Backend engineers can work on mapped persistence/session semantics while the Godot engineer builds responsive controls against validated fixture DTOs. Integrate before claiming acceptance. QA can prepare cases and runbook hooks early. Human content/privacy decisions may proceed independently when the actual materials/protocol are available.

## Effort and timing

Sizes XS/S/M/L are relative planning estimates, not elapsed days or commitments. Larger native/security tasks should be split into implementation PRs while keeping one issue's complete acceptance. Re-estimate after GDM-001; do not promise a date based on the old closed-issue count.

## Scope of “MVP complete”

Internal MVP requires GDM-001–026, real browser/Android evidence and a clear fixture-versus-reviewed-content statement. The six pilot issues may stay open without falsifying an internal engineering completion claim. Conversely, an internal completion claim must not hide a missing device, inaccessible equivalent, failed security test, or unexecuted acceptance run.

Pilot tasks are not all external approvals: GDM-030 is engineering/QA blocked on observations; GDM-031 is operational execution. Keep the distinction visible in every report. No public-launch milestone is included.
