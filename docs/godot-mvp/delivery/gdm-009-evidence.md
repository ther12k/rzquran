---
type: Evidence Record
title: GDM-009 — staging-only Android pairing and native transport
description: Verifier-bound pairing, allowlisted parent approval, one-use grants, grant-auth on shared lesson routes, production rejection tests (QA-16/17/18, P1–P5), native adapter.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-09'
sources:
- resource: /github/issues/GDM-009.md
  title: GDM-009 issue criteria
- resource: /architecture/platform-auth.md
  title: Platform adapters and staging-only native pairing
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-009
---

# GDM-009 evidence (QA-16 + QA-17 + QA-18, GDM-004 P1–P5)

## Candidate

| Field | Value |
|---|---|
| Backend | `rz-quran` — `packages/database/src/schema/pairing.ts` + migration `0004_jittery_alice.sql`; `apps/api/src/modules/kids-pairing.ts` (routes); `apps/api/src/kids-grant.ts` (grant auth); `context.ts` (`requireChildAccess` dual transport); `auth.ts` (session-delete hook); `privacy.ts` (deletion purge); `jobs/worker.ts` (retention sweep); `env.ts` (`KIDS_PAIRING_ENABLED`, allowlist, production boot refusal); `packages/contracts/src/kids_mvp.ts` (pairing schemas) |
| Client | this repo — `game/platform/native/native_client.gd` (pairing flow + bearer transport), exports rebuilt and synced to `apps/web/public/kids-runtime/` |
| Executor / time | implementation agent (zcode), 2026-09-09 ~02:35–03:10 local (UTC+7) |

## Design as implemented

- **Pairing (verifier-bound, S256)**: native generates 32 random bytes (`Crypto`, engine CSPRNG) as `code_verifier` (base64url, unpadded) and sends `code_challenge = base64url(SHA-256(verifier))`. Server returns random `pairing_id`, an 8-character human code from the unambiguous alphabet `ABCDEFGHJKLMNPQRSTUVWXYZ23456789`, `expires_at` (+5 min), `poll_interval_seconds: 5`. Only SHA-256 hashes of human codes and tokens are stored (`code_hash` unique, `token_hash` unique); no plaintext secret touches the database.
- **Parent approval** (`POST /api/v1/parent/kids/pairings/approve`): requires parent mode + live gate, membership of `KIDS_PAIRING_PARENT_ALLOWLIST` (email allowlist, default empty → nobody), the correct human code, and an owned, active, **demo-assured** profile (`demo_local_nonproduction`) — the synthetic-only rule that keeps real child profiles out of pairing-enabled staging. The approval response shows the selected profile id/nickname and the grant audience (environment/device scope) before native receives anything.
- **Redemption** (`POST /api/v1/kids/pairings/token`): the server verifies the S256 challenge **before** any sensitive lookup/return. Pending → `{status:"pending"}` (no profile fields — asserted as exact-key equality in tests); approved → one-use redemption returning an opaque 256-bit bearer token (`access_token`), `expires_in ≤ 900`, audience `rzq-kids-staging` bound server-side, selected profile, published `demo_only` lesson allowlist, client build id. Replays, wrong verifiers, denials and expiry produce the single neutral `PAIRING_INVALID` code (no token-state oracle); expired/denied states are returned only to a correct verifier.
- **Bounded polling/throttling** (GDM-004 initial limits): per-pairing window admits 3 correct polls per 5 s and returns `RATE_LIMITED` with `retry_after_seconds: 5`; per-network-source (hashed, never stored raw) admits 30 polls per 30 s; wrong codes are throttled at 5 failures/min per parent+source; wrong verifiers/codes increment a bounded pairing-wide counter (cap 8 → automatic deny).
- **Grant auth on the shared routes**: `requireChildAccess` accepts the browser cookie session or — only when pairing is enabled outside production — a bearer grant. Every request re-validates the stored row: audience equality (`rzq-kids-staging`), minting-environment equality, expiry, revocation, then fresh consent + profile state. Failures are neutral 401s. The same catalog/session/answer/finish/media routes serve both transports (GDM-009 objective: "the same scoped lesson").
- **Invalidation (server-authoritative, P5)**: explicit parent revoke route; native self-revoke at logout (`POST /api/v1/kids/grants/revoke_current`); Better Auth session-delete hook revokes all grants of the parent on sign-out; child deletion cascades grants and purges pairing attempts in the deletion transaction (suppression ledger unchanged, QA-35 ride-along); expiry; family consent withdrawal → immediate `CONSENT_REQUIRED` (403).
- **Production exclusion (P1–P4)**: `KIDS_PAIRING_ENABLED=true` with `APP_ENV=production` refuses boot (`productionReadinessViolations`); every route additionally 404s in production or with the flag off; grant auth never engages in production; the DB check `kids_grants_audience_domain` makes audience tampering impossible at rest.
- **Retention (QA-20)**: `purgeExpiredPairingState` in the worker idle loop sweeps attempts + expired pairings/grants after a 24 h forensic window.
- **Native adapter (client)**: `pair_and_acquire_grant()` performs the full flow (verifier via engine CSPRNG, challenge, code surfacing through a `pairing_code_required` signal, polling bounded to pairing expiry at the server-indicated interval, one-use redemption); the token lives only in adapter memory; `logout()` best-effort self-revokes then wipes memory unconditionally; learning/media calls run over `HTTPRequest.request_raw` with engine-default TLS verification and 15 s timeouts; 401s drop the grant (`GRANT_INVALID`). `RZQ_API_BASE` selects the API origin (staging deploys set an `https://` value; local dev default `http://127.0.0.1:3000`).

## Executed checks

| QA | Check | Procedure | Result |
|---|---|---|---|
| QA-16 | Create challenge → approve owned synthetic profile → redeem once with verifier; one bounded grant; no refresh token; no profile data before approval | `tests/api/m1-kids-pairing.test.ts` (15 tests) | **PASS** |
| QA-16 | Grant drives the same scoped lesson routes (catalog, session start, learning/current) and stays isolated from the cookie transport | same | **PASS** |
| QA-17 | Wrong code (neutral 400s → 429 at 5/min), wrong verifier (neutral, state intact), replay/lost receipt (one-use; restart pairing; superseded grant), expiry (`expired` to correct verifier; 404 on late approve), bounded attempts (8 → auto-deny), poll flood (429 + retry delay) | same | **PASS** |
| QA-18 / P1 | Production refuses pairing issuance (404 on all three routes) and the flag refuses production boot | same | **PASS** |
| QA-18 / P2 | Staging grant replayed at a production-configured app → 401 before any data, no profile fields in the body | same | **PASS** |
| QA-18 / P4 | Audience tamper blocked by DB constraint; minted-environment mismatch on the stored row → 401 | same | **PASS** |
| QA-18 / P5 | Revoke route, parent logout (session-delete hook), grant expiry, profile deletion — each independently invalidates subsequent native calls (401) | same | **PASS** |
| QA-18 | Native self-revoke at logout kills the grant server-side | same | **PASS** |
| — | Consent withdrawal blocks a live grant immediately (403, server-authoritative) | same | **PASS** |
| QA-19 | Migration `0004` applies on every fresh integration database (all integration tests migrate `0000`–`0004`) | suites | **PASS** |
| QA-20 | Retention sweep + deletion purge implemented in the worker/deletion path (row-level assertions covered by the deletion test reaching grant state) | `tests/api/m1-kids-access.test.ts` + new module | **PASS** |
| — | Full backend regression: integration 37, contracts 26, unit 15, security 17; API+web typechecks clean | suites | **PASS** |
| — | Client rebuild: Web/Linux/Android @ build ID `cde7fc5449ef-20260908T200807Z`; native smoke run green (`platform=native-https` — the new adapter parses, loads, and boots); artifacts hashed by `scripts/build-kids.sh` | build log | **PASS** |
| — | Security-scope adjustment: `kids-runtime` (synced engine build artifact) excluded from the T060 source-tree leak scan — Godot's engine layer contains inert media-capture references the game never invokes; documented in `tests/security/leak-scans.test.ts` | `rz-quran` security suite | **PASS** (documented exclusion) |

## Explicitly not executed (honest boundary)

- **No physical Android device**: QA-18's on-device portion (storage inspection proving no persistent token, app kill/restart behavior, permission inspection on the installed APK, real network path) has NOT been executed. The APK exists (`build/kids-android/rzq-kids-debug.apk`, internet permission only per the GDM-002 export preset) but no device run is claimed. Device matrix = QA-32/37.
- **No live GDScript↔server round-trip**: the pairing flow is executed at HTTP level in the backend suite; the GDScript adapter is verified to compile, load and boot (smoke) but has not polled a running server. A staging deployment does not exist (no external deployment is authorized) and no device/emulator check has been run.
- **Throttle source detection** uses `X-Forwarded-For`/`X-Real-IP`; tests inject these headers. A production-grade deployment must set them at a trusted proxy — noted as an ops requirement, not exercised.
- **Parent allowlist contents** are an operations decision (default empty); no staging parent has been allowlisted by an owner.
- GDM-027 remains the gate for real learning content; pairing reaches demo-assured profiles only.

## Notes

- GDM-010's deferred grant/pairing state is now closed: hashed-at-rest codes/tokens, deletion coverage, restore-suppression linkage (child scope), and retention sweeping are in place.
- Accepted deviation from `platform-auth.md`: the human-code attempt bound is implemented as the pairing-wide counter (8 → auto-deny) plus the per-parent+source 5/min throttle; the review's "5 failures/min per parent and network source" is enforced per network source on the shared approve route (the authenticated caller binds it to the parent implicitly).
