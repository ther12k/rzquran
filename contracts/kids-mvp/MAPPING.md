# Kids-MVP contract mapping (GDM-003)

One agreed contract drives the Godot client and the accessible HTML equivalent. This note is the **explicit deviation record** required by GDM-003: every difference between the bundle's proposed [API contract](../../docs/godot-mvp/contracts/api.md) and the shipped wire shapes is listed here with its resolution. Per [ADR-002](../../docs/godot-mvp/architecture/adr-002.md), the contract's executable source of truth lives in the backend repository:

- Zod schemas: `rz-quran` → `packages/contracts/src/kids_mvp.ts` (deep-strict public projections, strict writes)
- Contract tests (QA-03/QA-04): `rz-quran` → `tests/contracts/kids-mvp.test.ts` (17 tests, all passing)
- Fixtures (byte-identical copies here): `rz-quran` → `contracts/examples/kids-mvp/{valid,invalid}/`

## Files in this directory

| File | Purpose |
|---|---|
| `kids-mvp.schema.json` | JSON Schema (draft 2020-12) mirror of the Zod source; `additionalProperties: false` throughout so extra private keys reject |
| `valid/bootstrap-fixture.json` | Client-composed bootstrap, fixture mode |
| `valid/session-reviewed-placeholder.json` | Active session projection with a current question (placeholder titles, no approved-content claims) |
| `valid/answer-feedback.json` | Answer outcome (flags only — never the correct option) |
| `invalid/*.json` | Unsupported version, leaked private key, 5 options, leaked answer map, missing asset id — each must reject |

## Proposed → actual (final mapping)

| Proposed (contracts/api.md) | Actual | Note |
|---|---|---|
| `GET /kids/bootstrap` | Client composes `GET /api/v1/me` + `GET /api/v1/catalog` + `GET /api/v1/learning/current` into `bootstrap` shape | GDM-004 decision; no new endpoint |
| `POST /kids/sessions` | `POST /api/v1/learning/sessions` (body `{lesson_id}`) | idempotency via `Idempotency-Key` header, not body field |
| `GET /kids/sessions/{sid}` | `GET /api/v1/learning/sessions/{id}` | same shape, see `session` $def |
| `POST /kids/sessions/{sid}/attempts` | `POST /api/v1/learning/sessions/{id}/answers` | `event_id` replay instead of `client_request_id` |
| `POST /kids/sessions/{sid}/finish` | `POST /api/v1/learning/sessions/{id}/finish` | returns `finishResult` (star + fraction); no `first_answer_correct_count` |
| `POST /kids/sessions/{sid}/abandon` | none yet | gap; new route in GDM-007 |
| `GET /kids/sessions/{sid}/media/{asset_id}` | `GET /api/v1/media/{assetId}/playback` (metadata); byte route pending | byte-serving gap in GDM-013 |
| `GET /parent/profiles/{id}/practice-summary` | `GET /api/v1/parent/children/{childId}/progress` | profile ≡ child |
| pairing/grant operations (4) | none yet | GDM-009, staging-only per GDM-004 |

## Accepted deviations (each traced to GDM-004)

1. **Session expiry**: existing 24 h TTL, not the proposed 15-min lesson cap (native grants still cap at 15 min).
2. **Answer conflicts**: first-answer-wins replay (`replayed` / `first_response` flags) instead of `409 QUESTION_ALREADY_ANSWERED`; a changed option returns the stored first outcome, never a second score.
3. **Idempotency**: `Idempotency-Key` header + `event_id`, not `client_request_id` body fields.
4. **Feedback**: `correct` boolean post-commit; no `feedback_code` / `next_question` field — clients refetch the session for the next question.
5. **Completion**: requires all required *units acknowledged* (the client acknowledges after each accepted answer), not literally "three accepted answers".
6. **Content mode**: `content_mode` is server-derived from the lesson's `demo_only` flag and environment; never from query parameters.

## Verification

Backend: `bun run test:contracts` in `rz-quran` — 26/26 passing (2026-09-08), including 17 kids-mvp QA-03/QA-04 tests. Client-side parsing against these fixtures is exercised by GDM-006+ client tests; the Godot/HTML clients must treat these fixtures as golden files.
