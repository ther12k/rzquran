---
type: Asset Specification
title: Font acquisition — no binaries included
description: Font acquisition — no binaries included.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- id: nunito
  resource: https://github.com/google/fonts/blob/main/ofl/nunito/OFL.txt
  title: Nunito — SIL Open Font License notice
- id: arabic
  resource: https://github.com/notofonts/arabic
  title: Noto Arabic — official project and OFL notice
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Font acquisition — no binaries included

## Proposed candidates, not an approved rendering decision

**Latin interface:** Nunito is a candidate for the rounded Indonesian interface. Its official font distribution includes an SIL Open Font License notice.[^nunito]

**Arabic letter rendering:** Noto Naskh Arabic is a candidate for the three-item letter activity. The official Noto Arabic project identifies its OFL licensing and build/release sources.[^arabic] This is not a claim that the final Qur’anic text layout or every required mark has been reviewed.

No font binaries are included in this ZIP. The preview uses the engine/editor fallback and must not be used as Arabic typography approval. Acquire the chosen files separately from their official projects, pin the exact release/file hashes, preserve the applicable license/copyright notices, and verify allowed packaging with the project owner.

Avoid a remote font request during child use: prefer locally packaged, reviewed fonts when the distribution rights permit. Record size and whether Latin and Arabic fallbacks behave correctly. Do not convert fonts into base64 blobs or screenshots to avoid the normal acquisition/review process.

## Rendering evidence

Prepare actual exported screenshots at the specified phone/tablet sizes. Test isolated letters, joining behavior when applicable, dots, required marks, line clipping, letterform recognition, LTR Indonesian navigation with explicit Arabic direction, and font fallback. Never manually reverse Arabic strings.

GDM-012 owns the rendering integration; GDM-023 owns real-device evidence; GDM-027 owns actual learning approval. A licensed font and a passing layout test are not the same as curriculum sign-off.

[^nunito]: https://github.com/google/fonts/blob/main/ofl/nunito/OFL.txt
[^arabic]: https://github.com/notofonts/arabic
