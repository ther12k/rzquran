---
type: Asset Specification
title: Godot import and runtime integration
description: Godot import and runtime integration.
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
- id: audio
  resource: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html
  title: Godot — Importing audio samples
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Godot import and runtime integration

## Safe adoption

1. Keep this standalone preview separate from the existing application. Open its `project.godot` in the editor pinned by GDM-002 and report the exact version.
2. Import the Theme and WAV assets. Inspect all controls and the explicit audio buttons. Record any parser/import/runtime errors; do not label the preview tested merely because files exist.
3. Copy only selected assets into the real project's asset directory. Merge resource references intentionally; do not overwrite `project.godot`, authentication, export presets or existing scenes.
4. Apply the Theme to the appropriate child-facing Control subtree. Replace fallback font selection only after the separate acquisition/rendering checks.
5. Use responsive containers and protect the original 48-logical-unit touch target requirement. Theme padding alone does not enforce minimum target dimensions; controls still need minimum size and layout tests.
6. Run the real MVP lesson and accessible HTML equivalent with unchanged server-side progress/content rules.

## Theme resource

The theme uses StyleBoxFlat rather than image-based panels. Godot documents its configurable backgrounds, corners, borders and related styling.[^style] There are no external textures or font resources referenced by the theme. The focus style is a starting point; inspect its visibility and interaction with normal/hover states in the pinned runtime.

The standalone preview demonstrates controls and audio only. Its example progress value is visibly labeled as a demo, not user data. It does not implement a lesson, correct-answer checking, mascot animation, pairing, authorized audio, or a complete accessibility solution.

## Audio

The supplied files are 48 kHz, 16-bit, mono PCM WAV files. Godot supports WAV, Ogg Vorbis and MP3, with different size/CPU tradeoffs.[^audio] Start with these tiny cues; only introduce compressed long-form media when required. Do not transcode an already-lossy pronunciation recording repeatedly.

In the real app, create separate UI-effects and instructional-audio paths. Effects are optional, never autoplay, and must be suppressed while instructional speech is playing. Stop sounds on exit, profile switch, terminal session state and recall as required. Do not interpret these tones as phonemes or substitute them for absent teaching audio.

The preview plays through its own AudioStreamPlayer after a button press. Production audio interruption, mute preference, lifecycle handling and web autoplay behavior still belong to GDM-013/GDM-016; the preview does not prove those requirements.

## Export checks

Run pinned-editor import, then web and Android debug exports using the repository's reviewed build configuration. Test the actual exported files on real devices; source-file sizes are not a measurement of final download size or decoded memory.

Exclude `references/`, documentation, original masters, private manifests and review records. No remote font/CDN dependency is required by this asset starter. Do not claim a standalone asset preview is the authenticated learning slice.

[^style]: https://docs.godotengine.org/en/stable/classes/class_styleboxflat.html
[^audio]: https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_audio_samples.html
