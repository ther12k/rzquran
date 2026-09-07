---
type: UX Specification
title: Mobile-first MVP screens and wireframes
description: Text wireframes, interaction states, and accessible alternate navigation.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: layout
  resource: https://docs.godotengine.org/en/stable/tutorials/ui/gui_containers.html
  title: Godot — Using Containers
- id: a11y
  resource: https://docs.godotengine.org/en/stable/classes/class_displayserver.html
  title: Godot — DisplayServer accessibility support
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# UX specification

The earlier six images are **visual references only**. This Markdown-only bundle contains no image files. Reuse their friendly green/pastel direction, but reduce density and avoid a full feature grid. Do not reproduce generated Arabic, dates, statistics or implied fluency from an image.

## Screen inventory

| ID | Surface | Main action | Required alternate/error state |
|---|---|---|---|
| U01 | Existing adult entry/profile picker | Select permitted profile | Auth required; no profiles; parent gate required |
| U02 | Native pairing | Display code and wait | Pending, denied, expired, offline, production unavailable |
| U03 | Web runtime loader | Load selected activity | Retry, unsupported runtime, HTML activity |
| U04 | Child home | Mulai belajar / Lanjutkan | No reviewed lesson; fixture badge; expired resume |
| U05 | Three learning examples | Dengar / Berikutnya | Loading, playing, replay, audio unavailable |
| U06 | Question round | Hear prompt; select one option | Pending submit, error, selection announced |
| U07 | Feedback | Replay or continue | Correct/wrong with text and icon; no color-only signal |
| U08 | Result | Kembali ke beranda / Coba lagi | Finish pending or failed; no false completion |
| U09 | Pause/terminal/exit | Resume or exit safely | Revalidating, expired, recalled, no connection |
| U10 | Equivalent HTML activity | Same learning task | Semantic focus, labels, accessible status |
| U11 | Existing parent summary | View practice result | No data; stale read retry; fixture label |
| U12 | Protected pairing approval | Approve synthetic profile | Invalid code, denied, expiry, ownership failure |

## Phone wireframes

```text
U04 — Home (390 logical units)
┌─────────────────────────────────┐
│ Halo, Aisyah!       [Keluar]     │
│ Yuk, belajar sebentar.           │
│ [SIMULASI — fixture only]       │
│                                 │
│  [small friendly illustration]   │
│  Mengenal Huruf Hijaiyah         │
│  Dengar, lalu pilih hurufnya.    │
│  [       Mulai belajar       ]   │
│                                 │
│  [Versi sederhana] (web)         │
└─────────────────────────────────┘

U06 — Question
┌─────────────────────────────────┐
│ [Kembali]          Soal 1 dari 3 │
│                                 │
│          [ Dengar suara ]       │
│  Pilih huruf yang kamu dengar.   │
│                                 │
│     [  ا  ] [  ب  ] [  ت  ]     │
│                                 │
│        [Periksa jawaban]        │
│                                 │
└─────────────────────────────────┘

U08 — Server-confirmed result
┌─────────────────────────────────┐
│       Latihan selesai!          │
│   Kamu sudah mencoba 3 soal.     │
│   Jawaban pertama tepat: 2/3    │
│   [          Coba lagi       ]  │
│   [    Kembali ke beranda    ]  │
└─────────────────────────────────┘
```

Letter examples illustrate intended layout, not an approved curriculum/font rendering. Review the final actual glyphs and audio before learning use. Do not put transliterated letter names on audio-question options if they unintentionally give away the task; learning examples can show reviewed names.

## Responsive rules

Use containers and anchors for reflow; Godot provides these controls.[^layout] Target 360–430 logical-unit phone widths with 16-unit side padding, 48-unit minimum touch controls, 12–16-unit gaps. At 768+, constrain text and use optional side instructions. At 1024+, center a comfortable activity area; don't stretch the phone across the screen. Landscape must remain usable through reflow/scroll, not cropped.

Protect safe areas and browser chrome changes. No fixed element can cover answers or the exit control. A 200% text-scale check applies to the HTML alternative; native readability is tested at actual accessibility/display settings and documented, not assumed equivalent.

## Interaction rules

Select → explicit confirm → disable repeat submit while pending → display server feedback → continue. No countdown, random confetti over Arabic, purchase-like reward, scare state, penalties for stopping, or competitive ranking. Animation is brief and removable with reduced motion. Optional sound effects must not overlap instructional audio.

On back/exit, explain that an unfinished session may not count. Do not obstruct exit. Stop audio immediately. Parent-only navigation is not exposed as a child tab. Native pairing shows the adult web instruction, not an embedded parent password form.

## Accessibility

Provide clear labels and keyboard/focus ordering in HTML, visible focus, large targets, text/icon feedback, reduced motion, and no drag-only gestures. Godot accessibility availability varies by platform; check its target-specific support rather than promising mobile parity.[^a11y] If Godot cannot support the required assistive flow, the HTML route must remain a genuine equivalent using the same content and progress rules. Before changing presentations, abandon/confirm the current session so both clients cannot submit competing answers unnoticed.

[^layout]: Godot — Using Containers.

[^a11y]: Godot — DisplayServer accessibility support.
