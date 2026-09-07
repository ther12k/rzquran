---
type: Asset Specification
title: Asset registry — actual files and missing inputs
description: Asset registry — actual files and missing inputs.
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

# Asset registry — actual files and missing inputs

This is packaging metadata, **not** the server-authorized content manifest, approval evidence, or a permission to publish. Included resources remain unreviewed for production. Reference PNGs must not ship inside the application.

## Included files

| Relative to asset-starter | Bytes | SHA-256 | Category |
|---|---:|---|---|
| `godot-starter/assets/audio/ui/ui_complete.wav` | 26,924 | `b37aa7d835d4382f8f2ed7b5e63b4f15974f8083d8f9761673f74256d2d07d40` | ui-audio |
| `godot-starter/assets/audio/ui/ui_confirm.wav` | 17,324 | `1c4103acc8b72ee869a9371c3ae6016a082c7ece59a6299b4e4bd74d0e2600f7` | ui-audio |
| `godot-starter/assets/audio/ui/ui_tap.wav` | 7,724 | `8c840c9234caf49be2c0f17cc681a0e6bf12f9a3b6513fc675777359d2d3b2fb` | ui-audio |
| `godot-starter/assets/ui/rzq_kids_theme.tres` | 4,429 | `178187e680150d93a2da7ec7e48a53856b8f9a4220aec214d5dda6d324b8d6f2` | godot-resource-or-code |
| `godot-starter/preview/asset_preview.gd` | 3,451 | `23065d37af62c697a8344c0017ebb753a0d71366bf5da90761ce12c8f6f1ff7a` | godot-resource-or-code |
| `godot-starter/preview/asset_preview.tscn` | 306 | `1cc7e7c7afd400c2a6ae5815cbc45f586d8dc51c4a38720941518aa73b8c6550` | godot-resource-or-code |
| `godot-starter/project.godot` | 483 | `948804fac3d9d602a48a5d5630c76414394348781f71103c05a91cd622cddb3a` | godot-resource-or-code |
| `references/01-home.png` | 1,556,359 | `f4ae3c87b0842fd0d87b7167a199bf98c5d0942cbefe2efbb23adf97f07e9d78` | reference-only |
| `references/02-learning.png` | 1,612,548 | `7ea78d1b4dd947039f2746258d29bd0e71db4ef92c0feef64c004ba74b9942ad` | reference-only |
| `references/03-memorization.png` | 1,648,010 | `606e0b9d0651fe1800321c7813ad6068fa99a62ed008d5b93fd115506ef96135` | reference-only |
| `references/04-quiz.png` | 1,499,463 | `37ca3ec652d5527735b53eff608c50c418708190675a39a657cd80dcb540c4be` | reference-only |
| `references/05-hijaiyah-game.png` | 1,643,164 | `2c0afbe636382d6a618c93279692a928ca8d275e8840a9d91a71bfb060293ec7` | reference-only |
| `references/06-parent-progress.png` | 1,356,538 | `777d2bcb20e4c5ea57b4209a4c4876b003fc37934a5dcb14b500e4975b77a1d3` | reference-only |

## Missing asset groups

The custom mascot/illustrated backgrounds, SVG icon set, external UI/audio packs, font binaries, reviewed three-letter recordings and approved learning release are not present. Their absence is intentional and documented; a source recommendation is not a file.

## Machine-readable inventory

The following fenced JSON is the canonical inventory for these supplied payload files. Verification is limited to byte integrity/metadata. It must never be fed into the production lesson publication route.

```json
{
  "schema_version": 1,
  "bundle_version": "1.1",
  "metadata_only_not_a_learning_manifest": true,
  "entries": [
    {
      "path": "godot-starter/assets/audio/ui/ui_complete.wav",
      "category": "ui-audio",
      "availability": "included",
      "bytes": 26924,
      "sha256": "b37aa7d835d4382f8f2ed7b5e63b4f15974f8083d8f9761673f74256d2d07d40",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/assets/audio/ui/ui_confirm.wav",
      "category": "ui-audio",
      "availability": "included",
      "bytes": 17324,
      "sha256": "1c4103acc8b72ee869a9371c3ae6016a082c7ece59a6299b4e4bd74d0e2600f7",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/assets/audio/ui/ui_tap.wav",
      "category": "ui-audio",
      "availability": "included",
      "bytes": 7724,
      "sha256": "8c840c9234caf49be2c0f17cc681a0e6bf12f9a3b6513fc675777359d2d3b2fb",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/assets/ui/rzq_kids_theme.tres",
      "category": "godot-resource-or-code",
      "availability": "included",
      "bytes": 4429,
      "sha256": "178187e680150d93a2da7ec7e48a53856b8f9a4220aec214d5dda6d324b8d6f2",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/preview/asset_preview.gd",
      "category": "godot-resource-or-code",
      "availability": "included",
      "bytes": 3451,
      "sha256": "23065d37af62c697a8344c0017ebb753a0d71366bf5da90761ce12c8f6f1ff7a",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/preview/asset_preview.tscn",
      "category": "godot-resource-or-code",
      "availability": "included",
      "bytes": 306,
      "sha256": "1cc7e7c7afd400c2a6ae5815cbc45f586d8dc51c4a38720941518aa73b8c6550",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "godot-starter/project.godot",
      "category": "godot-resource-or-code",
      "availability": "included",
      "bytes": 483,
      "sha256": "948804fac3d9d602a48a5d5630c76414394348781f71103c05a91cd622cddb3a",
      "source": "created-for-this-handoff",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/01-home.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1556359,
      "sha256": "f4ae3c87b0842fd0d87b7167a199bf98c5d0942cbefe2efbb23adf97f07e9d78",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/02-learning.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1612548,
      "sha256": "7ea78d1b4dd947039f2746258d29bd0e71db4ef92c0feef64c004ba74b9942ad",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/03-memorization.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1648010,
      "sha256": "606e0b9d0651fe1800321c7813ad6068fa99a62ed008d5b93fd115506ef96135",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/04-quiz.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1499463,
      "sha256": "37ca3ec652d5527735b53eff608c50c418708190675a39a657cd80dcb540c4be",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/05-hijaiyah-game.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1643164,
      "sha256": "2c0afbe636382d6a618c93279692a928ca8d275e8840a9d91a71bfb060293ec7",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    },
    {
      "path": "references/06-parent-progress.png",
      "category": "reference-only",
      "availability": "included",
      "bytes": 1356538,
      "sha256": "777d2bcb20e4c5ea57b4209a4c4876b003fc37934a5dcb14b500e4975b77a1d3",
      "source": "earlier-conversation-generated-mockup",
      "approval": "not-approved-for-learning-release",
      "godot_runtime_verified": false
    }
  ],
  "absent_assets": [
    "custom_mascot_poses",
    "decorative_background_layers",
    "third_party_icon_set",
    "third_party_ui_pack",
    "third_party_audio_pack",
    "font_binaries",
    "reviewed_letter_recordings",
    "approved_learning_release"
  ],
  "audio_statistics": [
    {
      "file": "godot-starter/assets/audio/ui/ui_tap.wav",
      "frequency_hz": 600,
      "duration_seconds": 0.08,
      "sample_rate_hz": 48000,
      "channels": 1,
      "sample_width_bits": 16,
      "peak_pcm": 2207,
      "human_listening_review": "not_executed"
    },
    {
      "file": "godot-starter/assets/audio/ui/ui_confirm.wav",
      "frequency_hz": 800,
      "duration_seconds": 0.18,
      "sample_rate_hz": 48000,
      "channels": 1,
      "sample_width_bits": 16,
      "peak_pcm": 2450,
      "human_listening_review": "not_executed"
    },
    {
      "file": "godot-starter/assets/audio/ui/ui_complete.wav",
      "frequency_hz": 1000,
      "duration_seconds": 0.28,
      "sample_rate_hz": 48000,
      "channels": 1,
      "sample_width_bits": 16,
      "peak_pcm": 2505,
      "human_listening_review": "not_executed"
    }
  ]
}
```
