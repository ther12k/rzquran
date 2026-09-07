---
type: Asset Specification
title: Custom artwork production brief
description: Custom artwork production brief.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- resource: ../references/04-quiz.png
  title: Earlier generated quiz mockup; visual reference only
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Custom artwork production brief

## Direction

Proposed mascot: one friendly yellow star, consistent with the earlier quiz reference. Use warm green accents and restrained pastel shading. No character name, logo, or final design approval is assumed. A mascot is decorative, never an authority on religious correctness.

The four requested poses are neutral/idle, attentive/listening, gentle encouragement after an incorrect attempt, and a modest celebration. Do not use a sad or punitive character for errors, tears, loss-of-life metaphors, or guilt about missed practice.

## Deliverables still to produce

| Proposed file | Specification | Status |
|---|---|---|
| `mascot_idle.png` | 512 × 512, true alpha, consistent padding and baseline | Not supplied |
| `mascot_listening.png` | Same character proportions and scale; no instructional text | Not supplied |
| `mascot_encouraging.png` | Warm, non-punitive gesture | Not supplied |
| `mascot_celebrating.png` | Brief feedback state; no compulsory endless loop | Not supplied |
| `background_home.png` | Optional text-free decorative layer; protect center content | Not supplied |
| `background_activity.png` | Optional quiet scene; no letter or answer hints | Not supplied |

Retain editable source files where available. A generated raster image is not automatically editable vector art. Generated assets need provenance, visual cleanup, consistency checks, and owner acceptance. Do not describe generation as a legal rights clearance or guarantee of exclusivity.

## Draft production prompt

Use this only when requesting new artwork; no image generation was performed for this starter:

> Create one original, child-friendly yellow star mascot for an Indonesian Qur’an-learning app. Rounded friendly silhouette, warm green accent, restrained pastel shading, readable at small mobile sizes. Neutral welcoming pose, isolated on a transparent background, no text, no letters, no logos, no watermark, no religious calligraphy, no background scene. Keep the character and shadows inside the canvas with consistent safe padding. This is decorative artwork, not educational text.

Once an actual anchor image is accepted, derive the other three poses from that image. Do not assume an opaque image ID or nonexistent file is a usable reference. Keep all labels and Arabic rendered by the application rather than baked into the art.

## Acceptance

Check identity consistency, alpha edges, export resolution, crop/padding, visual legibility at actual display size, reduced-motion behavior, obscured controls, and reference/master/runtime provenance. Record reviewer decisions against exact file hashes. The six previous mockups remain reference-only unless separately cleared and produced as individual runtime assets.
