---
type: Evidence Record
title: GDM-006 — authorized bootstrap, session and media reads
description: Executed QA-07/QA-08/QA-09 matrix, abandon semantics, bounded media gateway, rollback flag.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-08'
sources:
- resource: /github/issues/GDM-006.md
  title: GDM-006 issue criteria
- resource: gdm-010-evidence.md
  title: GDM-010 persistence evidence
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-006
---

# GDM-006 evidence (QA-07 + QA-08 + QA-09)

## Candidate

| Field | Value |
|---|---|
| Backend additions | `rz-quran`: abandon route + bounded media gateway in `apps/api/src/modules/learning.ts`; `KIDS_MVP_ENABLED` / `MEDIA_STORAGE_ROOT` env (fail-closed defaults); bindings carry env |
| Content | `fixture_shapes_tones_3` (GDM-005); one fixture unit wired to a real WAV in the test storage root for the streaming success case |
| Executor / time | implementation agent (zcode), 2026-09-08 ~23:00–23:35 local (UTC+7) |

## Design summary

- **Bootstrap** stays client-composed per the GDM-004 decision (`/v1/me` + `/catalog` + `/learning/current`); no aggregate endpoint.
- **Abandon**: child-scoped, `Idempotency-Key` idempotent; mutates only `active/paused`; time-expired sessions return neutral `{status:"expired", abandoned:false}` (server-authoritative terminal states are never rewritten); completed/recalled/replaced return neutral no-ops. Abandoning frees the one-writable-session slot (verified by immediate restart).
- **Media gateway** (`GET /api/v1/media/stream/:assetId?session_id=…`): requires child context + owned session + non-terminal release state (recalled → 410 `CONTENT_RECALLED`, abandoned/expired → 409/410), version-scoped asset membership, `verified` + `audio` + `deliveryPolicy=stream`, bounds 3 MiB / 20 s enforced from the registry row *and* the actual bytes, MIME must be `audio/*`, objectKey path-sanitized, `Cache-Control: no-store`, `X-Content-SHA256` echoed. Any miss → neutral failure; no storage root configured → `MEDIA_UNAVAILABLE` (fail closed).
- **Rollback switch**: both routes 404 when `KIDS_MVP_ENABLED` is off (default), satisfying the GDM-004 feature-flag decision.

## Executed checks

| QA | Check | Result |
|---|---|---|
| QA-07 | Second parent account: read/abandon/stream on another profile's session → 404 neutral (no status/membership disclosure) | **PASS** |
| QA-07 | Client cannot switch content mode (GDM-005 test, still enforced) | **PASS** |
| QA-08 | Expired session blocks answers (`SESSION_EXPIRED`); abandon is neutral no-op | **PASS** |
| QA-08 | Recalled session blocks media (`CONTENT_RECALLED` 410); recalled version blocks new starts (404) | **PASS** |
| QA-08 | Unreviewed (quarantine) asset → `MEDIA_UNAVAILABLE` | **PASS** |
| QA-09 | Success case: real WAV bytes served, correct MIME, `no-store`, SHA-256 header matches | **PASS** |
| QA-09 | Foreign (unlinked) asset → 404; oversize registry row and oversize on-disk file → blocked; malformed session id → 400 | **PASS** |
| — | Flag off: abandon/stream → 404 even unauthenticated (route not revealed) | **PASS** |
| — | Regression: integration 18/18, contracts 26/26, unit 7/7, security 17/17, typecheck clean | **PASS** |

## Explicitly not executed

- No native-client media consumption (GDM-009's grant flow does not exist yet); browser consumption of the gateway is exercised only at HTTP level here, not in a live browser (QA-31 later).
- Production media storage (S3/R2-style) is undecided; the gateway serves only from `MEDIA_STORAGE_ROOT` and fails closed otherwise — an owner decision is recorded as open in MAPPING.md.
- Contract compatibility version enforcement and client upgrade flows arrive with client integration (GDM-008/019).
