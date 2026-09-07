---
type: API Contract
title: MVP API compatibility contract
description: Proposed operations, JSON shapes, error semantics, and server-side guarantees.
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

# API contract v1

**Proposed application contract, not a claim that these routes already exist.** GDM-001/GDM-003 map it to existing endpoints; equivalent existing routes are preferred. Commit a mapping and executable schema/tests in the application repository. All client calls go to HTTPS. Browser requests retain existing auth/CSRF controls; native calls use the restricted staging grant from [platform/auth](../architecture/platform-auth.md).

## Operations

`/v1` is a proposed prefix. `sid` and `asset_id` are opaque server identifiers. No operation accepts a raw SQL expression, filesystem path, arbitrary media URL, parent identity assertion, or client-computed score.

| Operation | Purpose | Authorization | Success |
|---|---|---|---|
| GET `/kids/bootstrap` | Effective profile, one available lesson, content mode and contract/build compatibility | Browser child context or native grant | 200 |
| POST `/kids/sessions` | Start a version-pinned session | Same; lesson allowlist and ownership | 201; replay same response |
| GET `/kids/sessions/{sid}` | Read authoritative state/current question | Owner plus active context | 200 |
| POST `/kids/sessions/{sid}/attempts` | Commit one answer to current question | Owner; active grant/session/release | 200 |
| POST `/kids/sessions/{sid}/finish` | Record completion once after three rounds | Owner; active release; all answers present | 200 |
| POST `/kids/sessions/{sid}/abandon` | Stop an unfinished session | Owner; idempotent termination | 200 |
| GET `/kids/sessions/{sid}/media/{asset_id}` | Read permitted session asset bytes | Owner; active release/session; asset membership | 200 + MIME/hash; no-store |
| GET `/parent/profiles/{profile_id}/practice-summary` | Existing protected parent summary | Authenticated owning parent; existing parent gate | 200 |
| POST `/kids/pairings` | Create internal staging pairing challenge | Staging-only; bounded anonymous rate | 201 |
| POST `/parent/kids/pairings/approve` | Approve pairing for one synthetic profile | Staging allowlisted parent, recent gate, CSRF/ownership | 200 |
| POST `/kids/pairings/token` | Poll/redeem once using verifier | Staging pairing + valid challenge proof | 202 pending; 200 issued once |
| POST `/kids/grants/revoke` | Revoke the calling native grant | That grant; idempotent | 200 |

Parent account logout/revocation and profile deletion must invalidate associated grants through existing domain hooks. Do not create a new parent UI just for those hooks.

## General rules

JSON uses UTF-8; timestamps are ISO 8601 with timezone. Reject unknown fields in write payloads and enforce identifier/string/array lengths. `client_request_id` is a random UUID for session start, answer, finish and abandon. Scope replay records to the authenticated actor/effective profile, operation and resource; store a normalized payload hash. Exact replay returns the same committed response; a changed payload with the same key returns `409 IDEMPOTENCY_CONFLICT`. Authorization and invalidation checks still run before returning cached success, especially after deletion/recall.

Initial engineering replay retention: 24 hours in staging, or shorter if the existing privacy policy requires. GDM-004 resolves the retention mapping. The profile deletion path erases or legally suppresses all added replay/answer/grant data according to existing policy. A uniqueness constraint remains the final defense against duplicate completion after replay rows expire.

## Example: bootstrap

```json
{
  "contract_version": "1",
  "content_mode": "fixture",
  "profile": {"id": "profile_demo_01", "nickname": "Aisyah"},
  "lesson": {
    "id": "fixture-shapes-01",
    "title": "Latihan Simulasi",
    "release_id": "release_demo_01",
    "round_count": 3,
    "resume_session_id": null
  },
  "server_time": "2026-09-07T09:00:00Z"
}
```

Only public/profile-minimal fields are serialized. No email, birthdate, consent evidence, parent token, internal reviewer data or answer key.

## Example: start

```json
{
  "lesson_id": "fixture-shapes-01",
  "client_request_id": "25ea7c56-5ec4-4e99-b5cf-3cc78cd46a71",
  "contract_version": "1"
}
```

A start response contains `session_id`, `status: active`, `release_id`, `expires_at`, `total_rounds: 3`, three public `examples`, `current_question`, and `accepted_count: 0`. It never accepts `profile_id` as an authorization claim; effective profile comes from validated server context.

```json
{
  "session_id": "session_demo_01",
  "status": "active",
  "release_id": "release_demo_01",
  "expires_at": "2026-09-07T09:15:00Z",
  "total_rounds": 3,
  "accepted_count": 0,
  "examples": [
    {"id": "item_a", "display_text": "○", "audio_asset_id": "asset_a"},
    {"id": "item_b", "display_text": "□", "audio_asset_id": "asset_b"},
    {"id": "item_c", "display_text": "△", "audio_asset_id": "asset_c"}
  ],
  "current_question": {
    "id": "q_opaque_01",
    "position": 1,
    "prompt_audio_asset_id": "asset_prompt_opaque_01",
    "options": [
      {"id": "option_opaque_a", "display_text": "○"},
      {"id": "option_opaque_b", "display_text": "□"},
      {"id": "option_opaque_c", "display_text": "△"}
    ]
  }
}
```

These are structural demo identifiers, not real asset URLs or approved content. Even prompt asset IDs and filenames must not encode answer names. A learner can naturally recognize instructional audio; protecting server keys is not a claim that educational answers are secret from a human.

## Example: answer and feedback

```json
{
  "question_id": "q_opaque_01",
  "option_id": "option_opaque_b",
  "client_request_id": "a7ff00a8-e216-4429-8759-74f269c5ac35"
}
```

Successful response: `attempt_id`, `accepted: true`, `feedback_code: correct|not_yet`, `accepted_count`, `next_question` (same public shape or null), and `ready_to_finish`. Returning current-round feedback after acceptance is permitted; shipping the complete future key or `correct_option_id` is not.

Validate the question is assigned, current and unanswered; option belongs to it; profile/session/grant/release remain valid. Use a transaction and uniqueness constraint on `(session_id, question_id)` for exactly one accepted answer. A second different request for the same answered round returns `409 QUESTION_ALREADY_ANSWERED` plus an instruction to refetch, not a second score. Client moves to the next question only after displaying the acknowledged feedback.

GET session includes current state, accepted count and minimal `last_feedback` for resume. A response-lost retry must not submit a new answer key. Finish accepts only `client_request_id`, checks all three accepted rounds and writes one completion. Repeat finish returns the same server result.

```json
{
  "session_id": "session_demo_01",
  "status": "completed",
  "answered_count": 3,
  "first_answer_correct_count": 2,
  "first_answer_total": 3,
  "completed_at": "2026-09-07T09:03:20Z",
  "content_mode": "fixture"
}
```

No `mastery`, `memorized`, `fluency`, total client points or client timestamps become authoritative learning results.

## Media response

Require session and asset membership on every read; no public bucket enumeration. Initial bounds: 3 MiB per audio asset and 20 seconds per example/prompt, validated server-side before review/publish. Client aborts larger downloads and corrupt/unsupported media. Use a reviewer-approved actual encoding tested on both targets. Response includes the validated MIME, length and SHA-256 metadata. These checks detect corruption/limits, not religious correctness.

A gateway can deny new reads immediately after recall. Bytes already delivered cannot be retracted. Stop playback/clear buffers on any invalidation response and before background/resume replay. No service worker or offline content cache in this scope.

## Native pairing shapes

Create: `{code_challenge, challenge_method: "S256", client_build}`. Response: `{pairing_id, user_code, expires_at, poll_interval_seconds: 5}`.

Approve: `{user_code, profile_id}`; server enforces synthetic profile, ownership and recent parent gate. Poll/redeem: `{pairing_id, code_verifier}`; approved once returns `{access_token, token_type: "Bearer", expires_at, audience: "rzq-kids-staging"}`. Never return a refresh token. Wrong code, secret, audience, expiry, replay, denial and production-mode behavior have dedicated negative tests.

## Error envelope and client behavior

```json
{"error":{"code":"SESSION_EXPIRED","message_key":"session.expired","request_id":"request_opaque_01","retryable":false}}
```

| HTTP / code | Behavior |
|---|---|
| 400 `INVALID_REQUEST` | Fix invalid payload; don't blindly retry |
| 401 `AUTH_REQUIRED` or `GRANT_EXPIRED` | Clear credential/session state and request adult entry/pairing |
| 403 `PARENT_GATE_REQUIRED` | Only protected adult host handles gate; no in-game bypass |
| 404 `NOT_FOUND` | Neutral missing/unauthorized resource; no ownership disclosure |
| 409 `IDEMPOTENCY_CONFLICT` / `QUESTION_ALREADY_ANSWERED` | Refetch; never recalculate client result |
| 409 `CONTENT_UNAVAILABLE` | Show unavailable state; never substitute invented content |
| 410 `CONTENT_RECALLED` / `SESSION_EXPIRED` | Stop, clear active buffers, terminal state |
| 426 `CLIENT_UPGRADE_REQUIRED` | Explain incompatible build, return to safe host |
| 429 `RATE_LIMITED` | Respect `Retry-After`; don't busy-poll |
| 5xx or timeout | Preserve pending request ID; bounded retry/refetch; never claim saved |

Run ownership checks before explaining recall/expiry for resources outside the caller's scope. Reject response/log fields through explicit serializers, not a best-effort blacklist alone. No token or sensitive body in error logs.
