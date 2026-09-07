---
type: Design System
title: Design tokens and Indonesian interface copy
description: Implementation-ready visual values and concise child/parent text.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: i18n
  resource: https://docs.godotengine.org/en/stable/tutorials/i18n/internationalizing_games.html
  title: Godot — Internationalizing games
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Proposed tokens

These are product design choices, not sampled/verified values from the old PNGs. Check contrast and actual device rendering during implementation. Do not ship font binaries from this documentation bundle.

| Token | Proposed value | Use |
|---|---|---|
| canvas | `#F7FBF8` | Warm neutral background |
| text-primary | `#17372B` | Readable body/headings |
| action-primary | `#226544` | Filled primary control with white text |
| surface | `#FFFFFF` | Cards |
| support-lilac | `#EDE8FA` | Nonessential supporting fill |
| support-yellow | `#FFF1C2` | Friendly callout, dark text |
| danger-text | `#A12424` | Errors with icon and explanation |
| spacing | `4, 8, 12, 16, 24, 32` | Logical units |
| corner | `12` control, `20` card | Rounded without decorative clutter |
| text | `18` body, `24–30` title | Adapt for final font and language |
| touch-minimum | `48 × 48` | Project minimum, independently test rendered size |
| animation | `120–220 ms` | Decorative transitions; zero/reduced mode |

Use a permitted rounded Latin font or platform fallback; choose a separately licensed, reviewed Arabic font with correct diacritics/glyph behavior. Godot supports bidirectional text, but the actual selected font and layout still need review.[^i18n] Keep Indonesian navigation LTR and Arabic text direction explicit. Do not reverse Arabic strings manually or flatten letters into screenshot crops.

## Copy dictionary

| Key | Indonesian copy | Context |
|---|---|---|
| home.greeting | Halo, {nickname}! | Synthetic/parent-provided display name; escape as text |
| home.subtitle | Yuk, belajar sebentar. | No daily pressure |
| lesson.title | Mengenal Huruf Hijaiyah | Reviewed-learning mode only |
| fixture.title | Latihan Simulasi | Engineering fixture mode |
| fixture.banner | SIMULASI — BUKAN MATERI BELAJAR | Visible throughout fixture mode |
| action.start | Mulai belajar | New session |
| action.resume | Lanjutkan | Server says session resumable |
| action.listen | Dengar suara | Explicit audio action |
| action.replay | Dengar lagi | Replay authorized prompt |
| question.instruction | Pilih huruf yang kamu dengar. | Shapes fixture uses “Pilih bentuk yang sesuai.” |
| question.progress | Soal {current} dari {total} | Total is 3 in MVP |
| action.check | Periksa jawaban | Disabled until selection |
| action.next | Berikutnya | After acknowledged feedback |
| feedback.correct | Tepat! Yuk, lanjut. | Server-confirmed only |
| feedback.retry | Belum tepat. Yuk, dengarkan lagi. | No shame or life penalty |
| result.title | Latihan selesai! | Finish acknowledged only |
| result.body | Kamu sudah mencoba {count} soal. | Practice, not fluency |
| result.accuracy | Jawaban pertama tepat: {correct}/{total} | Denominator required |
| result.retry | Coba lagi | Creates new session |
| action.home | Kembali ke beranda | Stops audio |
| load.wait | Sedang menyiapkan latihan… | Do not use fake percent |
| network.wait | Koneksi terputus. Jawabanmu belum terkonfirmasi. | Ambiguous request state |
| action.retry | Coba sambungkan lagi | Reuses pending request key |
| session.expired | Sesi ini sudah berakhir. Yuk, mulai lagi. | No merged/retroactive progress |
| content.unavailable | Materi ini belum tersedia. | Approval/missing pack |
| content.recalled | Materi ini sedang diperiksa. Pilih kegiatan lain. | No frightening detail |
| audio.failed | Suara belum bisa diputar. Coba lagi. | Never silently fake audio |
| web.simple | Gunakan versi sederhana | Equivalent HTML link |
| pairing.title | Minta bantuan orang tua | Internal Android flow |
| pairing.expires | Kode ini berlaku selama 5 menit. | Server expiry is authoritative |
| pairing.wait | Menunggu persetujuan orang tua… | No profile disclosure |
| parent.sessions | Sesi latihan selesai | Count distinct finished sessions |
| parent.lessons | Materi yang pernah dilatih | Distinct lesson IDs |
| parent.note | Hasil latihan bukan penilaian hafalan atau kelancaran. | Adult summary qualifier |

Do not use “sudah hafal,” “pasti lancar,” “nilai iman,” or “anak tertinggal.” Avoid mixing “Quiz/Progress/Games” with Indonesian when a clear “Kuis/Perkembangan/Permainan” label is available. This MVP does not need those tabs.

[^i18n]: Godot — Internationalizing games.
