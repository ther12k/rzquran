---
type: Evidence Record
title: GDM-007 — transactional answer, finish and replay semantics
description: Executed QA-10..QA-13 results, route-layer strict schemas, and the recorded replay deviations.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-09'
sources:
- resource: /github/issues/GDM-007.md
  title: GDM-007 issue criteria
- resource: ../../../../contracts/kids-mvp/MAPPING.md
  title: Accepted contract deviations
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-007
---

# GDM-007 evidence (QA-10 + QA-11 + QA-12 + QA-13)

## Candidate

| Field | Value |
|---|---|
| Backend | `rz-quran` — strict write schemas adopted at the three learning write routes; `tests/api/m1-kids-semantics.test.ts` (4 tests) |
| Content | `fixture_shapes_tones_3` (GDM-005) |
| Executor / time | implementation agent (zcode), 2026-09-09 ~02:00–02:15 local (UTC+7) |

## Route-layer strictness (with GDM-003)

`POST /learning/sessions`, `/events`, and `/answers` now parse with the deep-strict contract schemas (`kidsStartSessionStrictSchema`, `kidsEventBatchStrictSchema`, `kidsAnswerRequestStrictSchema`): unknown fields — including client-computed results like `correct` or identity assertions like `profile_id` — reject with `VALIDATION_ERROR` instead of being silently stripped.

## Executed checks

| QA | Check | Result |
|---|---|---|
| QA-10 | Two concurrent identical answers (same `event_id` + choice): both 200, identical stored outcome, exactly one `first_answers` row | **PASS** |
| QA-10 | Two concurrent finishes with the same Idempotency-Key: both 200, exactly one `first_completion_star` row for child+lesson | **PASS** |
| QA-11 | Same start key + changed payload → strict schema rejects (400) before idempotency; payload-hash conflict path (`IDEMPOTENCY_CONFLICT` 409) remains covered by existing suites | **PASS** |
| QA-11 | Answer replay with same `event_id`, changed option → stored first outcome returned unchanged (`selected_option_id`, `correct` identical); never a second score | **PASS** |
| QA-11 | Recalled version/session: answers, finish fail closed (`SESSION_EXPIRED`), no progress via replay | **PASS** |
| QA-12 | Foreign `question_id` → `VALIDATION_ERROR`; unknown option → `VALIDATION_ERROR` | **PASS** |
| QA-12 | Sequence gap → `EVENT_SEQUENCE_CONFLICT` with `last_accepted_sequence` hint; valid next event then succeeds (cursor consistent) | **PASS** |
| QA-13 | Finish before all rounds → 409 `INCOMPLETE_SESSION` with `remaining_unit_count` | **PASS** |
| QA-13 | Repeat finish after replay-row purge → 200, `star_awarded: false`, still exactly one star row (uniqueness survives retention) | **PASS** |
| QA-13 | No mastery/fluency wording in finish payload (regex scan: `hafal|mahir|lancar|mastery|fluency`) | **PASS** |
| — | Regression: integration 22/22, contracts 26/26, unit 15/15, security 17/17, typecheck clean | **PASS** |

## Recorded deviations (traceable to GDM-004, listed in MAPPING.md)

- Answer replay keeps the stored first outcome rather than returning `409 QUESTION_ALREADY_ANSWERED` — same intent (never a second score, client displays recorded result), different shape.
- Idempotency rides `Idempotency-Key` header + `event_id`, not body-level `client_request_id`.
- Completion requires required units *acknowledged*; the client acknowledges after each accepted answer.

## Client rule surfaced by these tests (for GDM-011+)

After every `answers` call the client must refetch or adopt the server-returned `sequence` — every answers call consumes a sequence slot, including replays. Tests use the server cursor (`last_sequence + 1`) rather than trusting echoed values.

## Explicitly not executed

- Concurrent cross-account races on the same child (two browser sessions, same profile) — server serializes per-session with `FOR UPDATE`; not exercised with real parallel browser clients (QA-28 territory).
- Load/concurrency volume (QA-38, GDM-024).
