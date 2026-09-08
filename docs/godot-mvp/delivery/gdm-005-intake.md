---
type: Intake Record
title: GDM-005 — three-letter learning-pack intake (UNAPPROVED)
description: Preparation table for real asset review; every decision field is blank pending actual human evidence (GDM-027).
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-08'
sources:
- resource: /contracts/content.md
  title: Reviewed content versus engineering fixtures
- resource: /github/issues/GDM-027.md
  title: GDM-027 human content gate
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-005
---

# Learning-pack intake — three Hijaiyah letters (UNAPPROVED)

**Status: intake preparation only. No field below is an approval. Publishing real learning content requires GDM-027's actual human evidence (rights, curriculum, rendering, audio).** The engineering fixture (shapes and tones, `fixture_shapes_tones_3`) is the only seeded content and is visibly non-learning.

## Pack identification

| Field | Value |
|---|---|
| Intended lesson | Three-letter Hijaiyah listening activity (MVP) |
| Curriculum reviewer | **Unassigned** — reviewer confirms the exact three letters and pedagogical names |
| Target content mode | `reviewed_learning` (server-authorized; unreachable until this pack is approved and published through the existing editorial workflow) |

## Per-letter intake (reviewer fills; agent must not prefill)

| Item | Letter identity (exact glyph + name) | Chosen font + version/hash | Rendering check (target sizes, no clipping/reversal) | Audio file + SHA-256 | Audio-letters alignment check | Recording permission (scope: web + Android APK distribution) | Reviewer + date |
|---|---|---|---|---|---|---|---|
| 1 | *TBD by reviewer* | *TBD* | *Not performed* | *None* | *Not performed* | *Absent* | — |
| 2 | *TBD by reviewer* | *TBD* | *Not performed* | *None* | *Not performed* | *Absent* | — |
| 3 | *TBD by reviewer* | *TBD* | *Not performed* | *None* | *Not performed* | *Absent* | — |

## Checklist gates before any `reviewed_learning` publication (all unchecked)

- [ ] Letter identities and names confirmed by curriculum reviewer
- [ ] Font acquired from official source; OFL notice + exact version/hash recorded; glyph rendering reviewed at 360/390/430 widths
- [ ] Each recording checked against its displayed letter (alignment, trim points, loudness consistency without distortion)
- [ ] Usage rights cover this client AND native APK bundling (a prior web permission does not automatically cover the APK)
- [ ] Immutable asset hashes registered in the content source registry (admin workflow)
- [ ] Two-person review completed via the existing editorial workflow (self-review stays blocked)
- [ ] Release hash computed and published through `curriculum_releases`

Until every box is checked by the actual humans who own it, the server keeps serving `fixture` mode for engineering and honest "Materi ini belum tersedia." for anything else. There is no fallback to generated recitation, mockup crops, or UI tones as teaching material.
