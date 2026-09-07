---
type: Asset Specification
title: Learning audio intake and approval
description: Learning audio intake and approval.
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
  title: Original MVP content contract; preserved unchanged in companion bundle
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Learning audio intake and approval

## Do not confuse interface cues with learning assets

The three supplied WAV files are generated interface tones. They contain no speech. They do not implement the real three-letter lesson or certify pronunciation.

For the learning MVP, a curriculum reviewer first confirms the exact three letter identities and pedagogical names. Alif, Ba and Ta are illustrative choices in the original wireframe, not approval evidence. Have a qualified adult teacher record the confirmed names, with documented permission for the intended browser and native delivery. Do not record children for this purpose.

Use a quiet recording environment, keep an uncompressed master, and prepare consistent playback copies without altering consonants or clipping the beginning/end. Avoid background music. Review the rendered glyph and corresponding playback together on the actual targets. Automated audio checks cannot certify pronunciation.

## Intake table — complete with actual evidence

| Item ID | Reviewed letter/name | Original master | Runtime asset ID + hash | Rights evidence | Glyph/audio reviewer | Allowed environments | Decision |
|---|---|---|---|---|---|---|---|
| Pending item 1 | Pending | Not supplied | Pending | Pending | Unassigned | None yet | Not approved |
| Pending item 2 | Pending | Not supplied | Pending | Pending | Unassigned | None yet | Not approved |
| Pending item 3 | Pending | Not supplied | Pending | Pending | Unassigned | None yet | Not approved |

Record exact source, performer permission, editing rights, fetched-versus-bundled scope, caching restrictions, reviewer identity, date, immutable hashes and content-release linkage. Do not infer native-bundling permission from web availability. A hash proves which bytes were considered; it does not prove content accuracy or a valid license.

## Existing issue ownership remains authoritative

[GDM-005](../../mvp-docs/github/issues/GDM-005.md) prepares fixtures and intake. [GDM-012](../../mvp-docs/github/issues/GDM-012.md) implements rendering. [GDM-013](../../mvp-docs/github/issues/GDM-013.md) implements playback. [GDM-027](../../mvp-docs/github/issues/GDM-027.md) records actual rights/curriculum authorization. This addendum does not duplicate or bypass the human gate.

No approved pack means “Materi ini belum tersedia.” Engineering may deliberately use the original separately labeled shapes/tones fixture. Do not replace missing speech with the supplied UI cues and present it as Qur’an learning.
