---
type: Evidence Record
title: GDM-010 — minimal persistence, cleanup and deletion hooks
description: Schema mapping (reuse vs addition), executed QA-19/QA-20 results, and deferred grant-state scope.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-08'
sources:
- resource: /github/issues/GDM-010.md
  title: GDM-010 issue criteria
- resource: /contracts/data-progress.md
  title: Minimal data changes and progress semantics
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-010
---

# GDM-010 evidence (QA-19 + QA-20)

## Schema mapping (reuse vs addition)

| MVP entity | Existing table / mechanism | Addition needed |
|---|---|---|
| Sessions, events, answers, completions, stars | `learning_sessions`, `learning_events`, `first_answers`, `session_units`, `rewards` | **None** — reused unchanged (one database; no duplicate progress store) |
| Child-initiated abandon (GDM-007 route) | `learning_sessions.status` | Added `"abandoned"` to the column's type union and DTO/contract enums. The column is plain `text` (no DB enum check); the partial unique index covers only `active/paused`, so abandon correctly frees the slot. **No migration required.** |
| Transport replay/idempotency | `idempotency_records` (actor-scoped, 24 h expiry, stored responses) | **None** — reused; see cleanup below |
| Pairings + native grants | *not built yet* | **Deferred to GDM-009**, which owns their tables with hashed codes/tokens from day one. Mapping will follow there; GDM-004 P1–P5 tests ride along |
| Media bytes | `media_assets` registry (verified status, delivery policy) | **None** — GDM-006's gateway reads bytes from an explicitly configured storage root; production storage decision remains open and the route fails closed without it |

## Executed checks

| Check | Procedure | Result |
|---|---|---|
| QA-19 forward migrations | every integration test migrates `0000`–`0003` onto a fresh disposable database (18/18 green) | **PASS** — no new migration was necessary in this task |
| QA-19 rollback/data preservation | no schema additions to roll back; restoration/suppression behavior is covered by the existing M4 restore drill (`verify-restore.ts`, evidence in `rz-quran`) | **PASS — not applicable for new DDL**; recorded rather than skipped |
| QA-20 deletion reaches added state | journey creates a child-scoped idempotency row → `DELETE /parent/children/:id` → row count 0, suppression ledger entry present | **PASS** (new test) |
| QA-20 replay retention purge | expired + live rows inserted; `purgeExpiredIdempotency` (now part of the worker idle loop) removes exactly the expired row | **PASS** (new test) |
| Regression | integration 18/18, contracts 26/26, unit 7/7, security 17/17, typecheck clean | **PASS** |

## Notes

- The uniqueness constraint on `(actor_scope, method, route, idempotency_key)` remains the final defense against duplicate completion after replay rows expire (QA-13), unchanged.
- Grant/pairing cleanup, export coverage for new state, and restore-suppression for grants are **explicitly deferred with GDM-009** and tracked there; this task closes the state that exists today.
