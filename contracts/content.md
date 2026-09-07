---
type: Content Contract
title: Reviewed content versus engineering fixtures
description: Minimal lesson-pack schema and the distinct learning publication gate.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Content contract

## Two modes, separate authority

`fixture` proves interfaces with synthetic profiles and explicitly labeled non-learning materials. `reviewed_learning` requires current approved assets with usage rights and curriculum/text/audio checks. No document in this archive is an approved learning asset. The agent cannot change mode by modifying local JSON.

## Minimal release model

| Field | Rule |
|---|---|
| `schema_version` | `1`; reject unsupported major version |
| `lesson_id` / `release_id` | Stable lesson ID, immutable release ID |
| `mode` | `fixture` or `reviewed_learning`, server-authorized |
| `locale` | `id-ID` interface copy; Arabic items carry explicit text-direction hints |
| `title` | Plain text, length-limited |
| `items` | Exactly three public item definitions for this MVP |
| `rounds` | Exactly three private server question definitions |
| `assets` | Approved opaque ID, MIME, bytes, duration, SHA-256, provenance locator |
| `review_records` | References to actual approvals; absent is not approved |
| `permitted_environments` | Explicit server release permissions |
| `release_hash` | Hash over a deterministic manifest representation with documented canonicalization |
| `status` | Existing pending/reviewed/published/recalled lifecycle; do not replace it locally |

## Server-only versus public projections

Server-only manifest may contain the correct option mapping, provenance, review evidence and licensing restrictions. Public projections contain display text, option IDs, permitted media IDs, lesson summary and active question data only. Do not pass the server manifest through the browser bridge or compile it into PCK/APK output.

GDM-003 commits JSON Schemas for the actual projection and writes. Include three valid examples (fixture, reviewed projection with placeholders, feedback) and invalid cases (unsupported schema, missing media, extra private key, too many options, wrong Unicode handling). A schema validates structure, not curriculum accuracy or ownership rights.

## Review checklist for real learning mode

Reviewer confirms the exact three intended letters and pedagogical names, final font/glyph rendering at target sizes, every audio-to-letter alignment, start/end trimming, loudness consistency without distorting pronunciation, spelling, allowed use/distribution/caching, and immutable asset hashes. Content owner records who approved what and for which environment. The agent may prepare the table but must not prefill approval.

Reuse existing reviewed sources/assets only after checking that their license covers this client and distribution. A prior web permission does not automatically cover bundling a native APK. This MVP fetches private audio on demand; any proposed bundling requires a separate decision.

## Recall

Pin each session to its release. Publication changes don't silently switch an active session to a different answer key. Recall invalidates new start/media/attempt/finish operations. Preserve existing audit and retention rules. Document previously delivered media limits; do not promise impossible remote deletion of played audio.

## No-content behavior

No approved pack → child sees “Materi ini belum tersedia.” Internal developers may deliberately choose the fixture environment, with its badge and synthetic dataset. The application cannot quietly fall back from missing learning content to fake recitation or placeholder Arabic.
