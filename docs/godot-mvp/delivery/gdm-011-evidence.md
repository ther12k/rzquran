---
type: Evidence Record
title: GDM-011 — responsive Godot entry and one-lesson home
description: Child shell state machine, U04 home with fixture badge and distinct states, 70 automated scene checks plus 30 rendered screenshots at five target sizes.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-09'
sources:
- resource: /github/issues/GDM-011.md
  title: GDM-011 issue criteria
- resource: /design/ux.md
  title: Mobile-first MVP screens and wireframes
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-011
---

# GDM-011 evidence (QA-21, engineering level)

## Candidate

| Field | Value |
|---|---|
| Scenes | this repo — `game/scenes/entry/main.gd` (composition root + lesson state machine), `game/scenes/home/home.gd/.tscn` (U04 home), `game/scenes/lesson/lesson.gd/.tscn` (lesson shell for GDM-012+), `game/services/copy.gd` (Indonesian copy source), `game/tests/qa21_shots.gd/.tscn` (QA-21 harness) |
| Build | all three targets rebuilt @ build ID `057e41a2e07d-20260909T015947Z` from this commit, smoke green (`platform=native-https`) |
| Executor / time | implementation agent (zcode), 2026-09-09 ~03:20–03:50 local (UTC+7) |

## Design as implemented

- **State machine** (godot-structure.md): `BOOT → LOADING_HOME → HOME → STARTING → LESSON → (Kembali) → HOME`, plus `EXITING`. Every (re)entry into HOME refetches `bootstrap()` from the server — state is never assumed across back-navigation (platform-auth: server invalidation is authoritative).
- **Distinct states, one screen contract**: loading (`Sedang menyiapkan latihan…`, no fake percent), home (greeting + subtitle + at most one fixture banner + exactly one primary start/resume action), unavailable (`Materi ini belum tersedia.` / version-mismatch / recalled variants — never rendered with the start card), recoverable error (message + `Coba sambungkan lagi`), and exit (`Keluar`) reachable in EVERY state including loading and error. Resume vs new is server-derived (`active_session.status ∈ {active, paused}`).
- **Fixture badge**: `SIMULASI — BUKAN MATERI BELAJAR` banner driven by the server-derived `content_mode` — never a query parameter, never client-switchable; card title uses the fixture name in fixture mode.
- **Parent navigation absent**: the only exits are `Keluar` (ends the runtime) and the lesson's `Kembali` (to home). No parent tabs, no pairing UI in the child shell.
- **Responsive reflow**: real Controls/Containers only — full-rect `ScrollContainer` → width-capped `VBox` column (max 480 dp, `custom_minimum_size` recomputed on resize, 16 dp side margins), autowrap on all text labels, `≥48 dp` touch minimums on every button (start is 56 dp), landscape stays usable by vertical scrolling instead of cropping, tablet/desktop centers the capped column instead of stretching.
- **No screenshot-based UI, no auto audio**: every visual is a Godot Control styled by `rzq_kids_theme.tres` (StyleBoxFlat); AudioService is wired only for teardown (`stop_all()` on exit) and nothing plays without an explicit tap (no learning audio exists yet at all).
- **Lesson shell honesty**: the content area is intentionally empty in this task; the explanatory note renders only in debug builds (`OS.is_debug_build()`), so release builds show a clean non-misleading surface until GDM-012/013/014/015 land.

## Executed checks

| QA | Check | Procedure | Result |
|---|---|---|---|
| QA-21 | Reflow invariants at five target sizes — small phone 360×640, large phone 430×800, tablet 768×900, desktop 1280×800, landscape phone 640×360 | `game/tests/qa21_shots.gd` (70 automated assertions): start/exit/back buttons ≥48 dp, start/exit inside the visible area, banner visibility per mode, resume-vs-start copy, state distinctness (loading hides start; unavailable hides card; error shows retry), column width cap | **PASS** (70/70) |
| QA-21 | Rendered layouts at those sizes for human review | 30 PNG screenshots saved by the same harness (`build/qa21/`, set sha256 prefix `4d58b2b5a73242b0`), visually inspected by the implementer: banner/card/button hierarchy per the U04 wireframe; no clipped or overlapping controls at any target size | **PASS** (implementer-reviewed) |
| — | Composition root boots from the export and prints the dev line | build smoke run (exported Linux binary): `[rzq-kids] build=… platform=native-https` | **PASS** |
| — | **Live follow-up (2026-09-09)**: portrait base resolution set (`window/size/viewport_*` = 390×844) after the live browser run showed the engine default 1152×648 base shrinking the UI to ~⅓ scale; width-cap now applied explicitly in `_ready` (anchored controls size before `resized` connects). QA-21 re-run green (70/70); live Chrome render at 390×791 matches the U04 wireframe | live e2e + QA-21 re-run + screenshot | **PASS** |
| — | Theme applied in harness renders (real StyleBoxFlat controls, not fallback styling) | harness loads `rzq_kids_theme.tres`; screenshots show themed buttons/cards | **PASS** |
| — | Full regression of prior tasks unaffected: backend integration 37, contracts 26, unit 15, security 17 (rz-quran @ `6ae8de1`) | suites (unchanged by this task; re-verified this session) | **PASS** |

## Explicitly not executed (honest boundary)

- **No physical device**: QA-21's device matrix (safe-area insets/notches, OS display scaling, real touch targets, GPU differences) belongs to QA-32/37 and has NOT been executed. Screenshots come from the desktop engine build at logical target sizes.
- **Reduced motion**: nothing animates yet (no transitions in this task), so the reduced-motion setting has nothing to exercise; the check stays open for GDM-014/015 where motion appears (QA-29).
- **Independent human layout review**: the 30 screenshots were reviewed by the implementing agent only; owner/designer sign-off on layout remains open.
- **Web export in a real browser** and the HTML equivalent (U10) are separate tasks (GDM-017/QA-31); not exercised here.

## Notes

- A harness-only lesson: OS-window resize on X11 is asynchronous, so the harness resizes an inner host Control instead (deterministic layout) and crops captures through the viewport's final transform (the project uses `canvas_items` stretch).
- The state machine intentionally keeps an unfinished session server-side when returning home; abandon semantics and exit-copy ("sesi belum selesai tidak dihitung") belong to GDM-016 and are not claimed here.
