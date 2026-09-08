---
type: Evidence Record
title: GDM-005 — bounded fixture and intake preparation
description: Executed QA-06 results, the answer-cursor defect found and fixed, and explicitly unexecuted checks.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-08'
sources:
- resource: /github/issues/GDM-005.md
  title: GDM-005 issue criteria
- resource: gdm-005-intake.md
  title: Learning-pack intake (unapproved)
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-005
---

# GDM-005 evidence (QA-06)

## Candidate

| Field | Value |
|---|---|
| Backend additions | `rz-quran`: `packages/database/src/seed-fixture-mvp.ts` (guarded fixture seed), `tests/api/m0-kids-fixture.test.ts` (QA-06), one cursor-consistency fix in `apps/api/src/modules/learning.ts` (below), `seed:fixture-mvp` script |
| Fixture content | `fixture_shapes_tones_3` — 3 display-only shape items (● ■ ▲, Indonesian labels) + 3 deterministic rounds; `demo_only=true`; `stage_key=fixture_engineering`; no audio assets, no Arabic, no recitation |
| Executor / time | implementation agent (zcode), 2026-09-08 ~20:45–20:57 local (UTC+7) |

## Executed checks (QA-06)

| Check | Procedure | Result |
|---|---|---|
| Fixture mode is server-controlled | `GET /catalog` — `demo_only` from DB; override attempt `?content_mode=reviewed_learning&demo_only=false` ignored | **PASS** |
| Visibly non-learning | title carries "(Fixture)"; `demo_only=true` end-to-end (catalog + lesson detail) | **PASS** |
| Exactly 3 items + 3 deterministic rounds | lesson detail: 6 units (3 letter-items + 3 choice rounds); deterministic outcomes verified (correct/correct/wrong-first) | **PASS** |
| No generated recitation / no Arabic in fixture | public lesson JSON contains no Arabic-range characters; no audio assets (`audio_asset_id` null everywhere) | **PASS** |
| No answer key in public projection | `correct_option_id` absent from lesson detail JSON | **PASS** |
| Absent-content fail closed | unknown lesson start → 404 `NOT_FOUND`; media playback without asset → 503 `MEDIA_UNAVAILABLE` (honest state) | **PASS** |
| Honest parent summary | after journey: `quiz_first_answers=3`, `quiz_correct_first_answers=2`, accuracy 67 (denominator present) | **PASS** |
| Seed guard | seed with `APP_ENV=production` → refuses | **PASS** |
| Regression | integration 15/15, contracts 26/26, unit 7/7, security 17/17, typecheck clean | **PASS** |

## Defect found and fixed during QA-06

**Answer-cursor desync (QA-12/QA-25 class).** `POST /learning/sessions/:id/answers`: when a *second distinct event* answered an already-answered question, the duplicate event row committed at the next sequence slot but `session.last_sequence` was not advanced. The sequence space then had a permanent hole: every later event/answer hit `EVENT_SEQUENCE_CONFLICT` (409) or a unique-violation 500 — the session was bricked. Fixed in `learning.ts`: the stored-first-answer branch now advances `last_sequence` to the committed event's sequence. All existing suites re-ran green after the fix. Client rule (recorded for GDM-006/007): adopt the server-returned `sequence` after every answers call; every call consumes a slot.

## Intake preparation

[Learning-pack intake](gdm-005-intake.md) committed with per-letter review fields (identity, font/hash, rendering, audio alignment, distribution rights) — all blank/unapproved by design. GDM-027 owns the actual human evidence.

## Explicitly not executed

- No client-side rendering of the fixture badge (GDM-011/012).
- No tones/audio in the fixture (display-only); audio lifecycle checks (QA-23/24) remain with the real audio path (GDM-013).
- Catalog counts in older tests assume only the pilot curriculum; fixture seed is opt-in per test file (setup unchanged).
