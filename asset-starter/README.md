---
type: Asset Specification
title: Asset starter — contents and limitations
description: Asset starter — contents and limitations.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- id: style
  resource: https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html
  title: Godot — StyleBoxFlat
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Asset starter — contents and limitations

Use this beside the [original MVP handoff](../mvp-docs/README.md). It does not supersede the PRD, content contract, architecture, or human approval gates.

| Deliverable | Actual status |
|---|---|
| `godot-starter/assets/ui/rzq_kids_theme.tres` | Included; editable button/card/progress styles; engine import unexecuted |
| `godot-starter/preview/` and `project.godot` | Included; standalone asset preview, not a lesson/game |
| Three `godot-starter/assets/audio/ui/*.wav` files | Included; generated non-speech cues; technical sample checks only |
| Six `references/*.png` mockups | Included unchanged; visual references only |
| Custom mascot / illustrated backgrounds | Not supplied; production brief included |
| SVG icon set / third-party UI and sound packs | Not supplied; official acquisition candidates documented |
| Arabic / Latin font files | Not supplied; acquisition and review instructions included |
| Three letter-pronunciation recordings | Not supplied; human recording/review intake included |
| Learning approval / production release approval | Not supplied; unchanged external gates |

Open `godot-starter/project.godot` using the editor version pinned by GDM-002. First import and inspect in the editor, then test web and Android. This project has not been run in Godot here. Its only audio is triggered by explicit buttons. Do not replace an existing game project configuration with this standalone preview configuration.

Prefer native Theme/Control styling for cards and buttons, because StyleBoxFlat can provide rounded borders and related styling without raster textures.[^style] The previous friendly green palette is retained as a proposed theme, not a validated final design.

[Agent instructions](HANDOFF_PROMPT.md) • [Asset specification](docs/asset-specification.md) • [Validation](docs/validation.md)

[^style]: https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html
