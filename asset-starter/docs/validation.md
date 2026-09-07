---
type: Validation Report
title: Asset starter validation and unexecuted checks
description: Asset starter validation and unexecuted checks.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- resource: ../../mvp-docs/contracts/content.md
  title: Original MVP content contract; unchanged companion bundle
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Asset starter validation and unexecuted checks

## Executed packaging checks

The build records byte-for-byte preservation of all 76 original MVP Markdown files; SHA-256 values for every included runtime/reference payload; parseable YAML/JSON metadata; file/path existence; reference-image readability; WAV header, duration and sample-statistic checks; and ZIP CRC integrity.

## Not executed

No Godot executable is installed in this environment. GDScript compilation, resource import, actual playback listening, browser/Android export, mobile rendering, accessibility, performance measurements, and human rights/content/design approval have not been performed. The preview is supplied as source to validate, not a tested application.

The six prior mockups are reused as reference files; this pass does not re-approve their visual/Arabic content. No new custom artwork was generated.

## Acquisition limitation

Official Kenney UI/audio source pages were checked, but binary downloads failed here. No third-party Kenney/Lucide assets or font files are in this package. Do not infer successful acquisition from documentation links.

## Audio scope

The three generated samples contain short mathematical tones, not speech. Peak/duration measurements detect encoding/range issues, not child suitability or pronunciation correctness. Their detailed parameters are in the registry.

## Reproduce file verification

Extract the fenced JSON from the registry, verify SHA-256 for each listed path relative to `asset-starter`, and reject mismatches. Re-run the project’s actual import/device/content checks before adoption. File hashing must not set a release to approved.

## Executed results for this build

| Check | Result |
|---|---|
| Original MVP files preserved unchanged | 76 |
| Included runtime/reference inventory entries verified | 13 |
| New-document local links resolved | 61 |
| New-document local provenance references resolved | 11 |
| Static res:// paths resolved | 6 |
| Godot Theme subresources referenced consistently | 8 |
| Reference PNGs decoded | 6 |
| WAV files checked and reproduced byte-for-byte | 3 |
| Bundled font binaries | 0 |
| Godot import/compile/runtime/device tests | NOT EXECUTED |

Audio technical checks:

- `ui_complete.wav`: 0.28s; peak absolute PCM sample 2505; 48 kHz / mono / 16-bit; endpoints zero.
- `ui_confirm.wav`: 0.18s; peak absolute PCM sample 2450; 48 kHz / mono / 16-bit; endpoints zero.
- `ui_tap.wav`: 0.08s; peak absolute PCM sample 2207; 48 kHz / mono / 16-bit; endpoints zero.
