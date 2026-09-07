---
type: Asset Specification
title: Minimum asset specification
description: Minimum asset specification.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- id: images
  resource: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
  title: Godot — Importing images
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Minimum asset specification

## Scope: one three-item activity, not the entire curriculum

The first engineering slice does not need a full character animation library, mosque environment, 3D objects, or prerecorded narration for every button. Keep custom illustration optional for internal testing; the activity must remain usable with plain controls.

| Category | Proposed MVP quantity | Required delivery | Included here? |
|---|---:|---|---|
| UI theme | 1 | Editable Godot Theme with normal/hover/pressed/disabled/focus states, cards, progress styles | Yes; engine validation pending |
| Navigation/action icons | 12 | Consistent SVG sources plus import tests; no icon-only critical controls | No |
| Mascot | 1 character, 4 poses | Idle, listening, encouragement, celebration; 512 × 512 transparent PNG each | No; custom-art brief |
| Decorative backgrounds | Up to 2, optional | Text-free layers; portrait/landscape-safe composition | No; plain canvas works initially |
| Interface cues | 3 optional | Tap, confirmation, completion; no voice, no autoplay, no shame buzzer | Yes; generated WAV |
| Fonts | 1 Latin and 1 Arabic family | Acquire approved versions separately, retain upstream notices, test final rendering | No binaries |
| Learning text | Exactly 3 reviewed item definitions | Unicode content from the server; never from generated images | No approved content |
| Pronunciation | 3 reviewed short recordings | One per approved item; alignment and rights evidence | No |
| Test fixture content | Existing GDM-005 scope | Explicit non-learning shapes/tones; no accidental promotion to real learning | Not implemented by this asset preview |

Suggested icon names: back, next, home, play, pause, replay, sound, mute, close, check, help, connection-error. Use one icon family. Put Indonesian accessible labels on real controls; do not bake button copy into images. Keep icons and the mascot decorative where text conveys the action.

## Visual and technical contract

Keep the proposed warm neutral canvas `#F7FBF8`, primary text `#17372B`, primary action `#226544`, lilac `#EDE8FA`, and pale yellow `#FFF1C2` from the original tokens. Test contrast in actual control states; a listed hex value is not accessibility approval.

Use original source artwork plus individually exported transparent PNG poses, not only a flattened sprite sheet. Standardize canvas dimensions, pivot/baseline, padding and character scale. Review alpha edges on both light and dark backgrounds. Text and Arabic must stay separate from illustration.

For SVG, avoid unsupported features and external dependencies. Godot's image importer documents default rasterization and available import modes; check behavior in the pinned editor rather than assuming unlimited vector sharpness at runtime.[^images] Do not include base64-embedded font files, externally loaded fonts, or scripts in artwork.

Do not stretch a portrait painting to landscape. Prefer a small decorative layer over the plain canvas or crop only decorative margins. Keep Arabic, choices and the exit control unobscured.

## Distribution boundary

Only explicitly permitted interface art/cues belong inside `res://assets/`. Private lesson audio remains outside the exported project and is fetched through existing authorization. Never bundle the private answer mapping or provenance/approval records into the public runtime. The public content projection is defined by the original [content contract](../../mvp-docs/contracts/content.md).

Do not package the six mockup screens into the game. Their numbers, dense layouts and generated Arabic are not requirements or source material.

[^images]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_images.html
