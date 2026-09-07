---
type: Security Review
title: GDM-004 — Engineering threat boundaries and native staging design
description: Technical review of the security checklist against inspected baseline facts, with resolved contradictions and specified tests.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-07'
sources:
- resource: /security/privacy-content.md
  title: Safety and threat checklist
- resource: /architecture/platform-auth.md
  title: Platform adapters and staging-only native pairing
- resource: gdm-001-baseline-inventory.md
  title: GDM-001 baseline inventory (rz-quran @ f1b43db)
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-004
---

# GDM-004 — Technical threat review (QA-05)

Scope: engineering threat boundaries for the MVP activity only. This review **resolves technical design questions**; content-rights, curriculum, privacy/legal and pilot decisions stay with their human owners (GDM-027/028/032). Nothing here authorizes production native login or external deployment.

Baseline facts referenced as `INV-§` point to [the GDM-001 inventory](gdm-001-baseline-inventory.md) (rz-quran @ `f1b43db`).

## Trust boundaries

```text
[Child/Apple/Android device]                     [Server (rz-quran)]
  Godot runtime (web iframe | native APK)  --HTTPS-->  /api/v1/* routes
        |  bridge messages (web only)                   requireChildSessionDb / requireParentGate
        v                                               | Drizzle transactions
  React host (same origin, adult session cookie)        PostgreSQL / private media
```

- The browser iframe/host bridge is an **availability and message-integrity boundary, not an authorization boundary** (`platform-auth.md`; QA-15 depends on this). All authorization is server-side, derived from the cookie session or native grant — never from bridge messages, query parameters, or client-asserted IDs.
- The web host holds the adult session cookie; the Godot runtime never receives it (no cookie value, no CSRF secret crosses the bridge). Parent/admin surfaces stay in React behind `requireParentGate` (`INV-§Identity`).
- The native app holds only an in-memory staging grant. It cannot call parent/admin routes: those routes resolve context from the Better Auth cookie session, which the native client never has; the grant token is not a cookie and is accepted only by the new kids/native module.

## Checklist walk (all 11 rows)

| # | Threat | Design resolution (inspected fact → decision) | Specified evidence |
|---|---|---|---|
| 1 | Child invokes adult action | Existing: mode+gate enforced server-side per request (`context.ts`); parent routes fail in child mode. New native module exposes **only** bootstrap/session/media/pairing-revoke actions; no route bridge to parent APIs. Approval screen is a new protected React route behind the live 5-minute gate. | QA-07, QA-15 (unauthorized child-context calls → `PARENT_GATE_REQUIRED`/`AUTH_REQUIRED`; no hidden-button path) |
| 2 | One profile sees another's answers | Existing owner-scoped queries everywhere (childId in every WHERE; `NOT_FOUND` on foreign IDs). New grant binds `profile_id` at approval; every native request resolves profile from the **grant row**, never from payload. Replay records keep the actor scope (`idempotency.ts` actorScope). | QA-07, QA-11 (cross-profile read/start/answer/replay → neutral failure; no cached cross-profile success) |
| 3 | Native bundle leaks auth/key material | Client receives public DTOs only (existing serializers never emit `correct_option_id` pre-answer, emails, or consent data). Grant token and pairing verifier live only in engine memory; no `user://`/localStorage/IndexedDB persistence; HTTP layer configured to strip `Authorization` from logs; no answer keys shipped in the PCK. | QA-33 (source/PCK/APK scan + runtime response/log inspection, recorded separately) |
| 4 | Pairing code guessing/replay | 8-char unambiguous-alphabet human code, 5-min pairing expiry, stored **hashed**; 32-byte `code_verifier` + S256 challenge verified before any state lookup; one-use redemption keyed on pairing row; polling ≥5 s interval, bounded; 5 code failures/min per parent+source; lost redemption response → restart pairing (no second token). | QA-16, QA-17 (wrong verifier/code, replay, expiry, poll flood → neutral errors + rate delay; single grant) |
| 5 | Staging credential reaches production | Grant carries `audience: rzq-kids-staging` bound **server-side** at issuance. Production (`APP_ENV=production`) refuses: pairing/token/approve/revoke routes are not mounted (module mount gated on env), and the token-auth middleware rejects any bearer token whose grant audience/environment does not match the serving environment, before any handler runs. Client-side config edits cannot fix an audience mismatch. | QA-18 + P-tests P1–P5 below (automated, in `rz-quran` security suite) |
| 6 | Duplicate/tampered progress | Existing: `SELECT … FOR UPDATE` transactions, sequence checks, first-answer-wins, uniqueness on rewards and `(session, question)` effect rows, payload hashing, stored-response idempotency (`INV-§Learning engine`). Client keeps one pending `request key` per logical action and never derives results locally. | QA-10, QA-12, QA-13 (concurrent duplicates → one mutation, same logical response; finish twice → one completion) |
| 7 | Recalled content keeps earning results | Existing session statuses fail closed on recall (`CONTENT_RECALLED`); every sensitive operation re-checks release state in-transaction. Media byte route (new) re-validates asset status + session membership per request; `Cache-Control: no-store` already set on child routes. Delivered bytes cannot be retracted — stated limitation, client stops playback and clears buffers on invalidation responses. | QA-08, QA-34 (recall between bootstrap/start/media/answer/finish/replay → fail closed; new media denied) |
| 8 | Abandoned session contaminates another profile | Session state is server-side; abandon (new route) is owner-scoped and idempotent. Client clears audio buffers, pending request keys, and scene state on exit, profile switch, logout, and any invalidation response; no offline queue exists to leak (`platform-auth.md`). Native process exit deliberately drops the grant. | QA-24, QA-28 (pause/resume/switch/kill → stale callbacks ignored, buffers cleared) |
| 9 | Restore resurrects deleted new state | Existing deletion uses a suppression ledger with a restore drill (`rz-quran` M4). New tables (idempotency already exists; grants, pairings, attempts state) must be added to the deletion path **and** the independent suppression workflow so restored backups re-suppress. | QA-20, QA-35 (delete profile with live grant/replay rows → revoke+erase; restore of old backup → suppression removes new state before access) |
| 10 | Arbitrary code/URL from content | Client renders only typed DTO fields; text-only display; media fetched only by server-issued asset IDs via the fixed API origin; no redirects with credentials; no URL/JS/HTML from payloads ever evaluated (bridge validates origin, nonce, action allowlist, 64 KiB JSON limit). Server rejects unknown fields and enforces length bounds (Zod). | QA-04, QA-09, QA-14 (malformed IDs/oversize/foreign asset/bridge fuzz → bounded rejection, no evaluation) |
| 11 | Unapproved learning/pilot exposed | Content mode is server-derived (`demo_only` flags, release status); fixture mode is a visible client badge fed by the bootstrap field, never by query parameters (`overview.md` Configuration). Native pairing exists only in staging; staging pairing allowlist excludes real child profiles. Preflight stays fail-closed tooling (QA-39), separate from real approvals. | QA-06, QA-39 (+ GDM-027/028 human evidence, not substitutable) |

## Data minimization — confirmed design

Only `nickname`, opaque IDs, and server-derived practice aggregates cross the API. No birthdate, photo, voice, location, contacts, ad identifiers, analytics SDKs, or persistent device IDs are introduced. Pairing/build identifiers are transient. Debug screenshots use synthetic profiles only (`security/privacy-content.md`).

## Resolved contradictions (from GDM-001)

| Contradiction | Resolution | Follows into |
|---|---|---|
| Proposed 15-min lesson cap vs existing 24 h session TTL | Keep existing 24 h server TTL (no behavior change to React flows). Native sessions are bounded by the 15-minute grant; browser sessions by the adult session. Recorded as an accepted deviation from `contracts/api.md` for the MVP; revisiting the cap is an owner decision. | GDM-007 records deviation; QA-13 uses existing TTL |
| `QUESTION_ALREADY_ANSWERED` 409 vs first-answer-wins replay | Keep first-answer-wins (existing). Same-intent replays return the stored result; changed-option resubmissions return the stored first answer with `first_response: false` — the client displays the recorded outcome and advances. Never a second score, satisfying the contract's intent. | GDM-007 test mapping (QA-11/12) |
| `client_request_id` body field vs `Idempotency-Key` header + `event_id` | Client adapter sends the UUID as `Idempotency-Key` (start/finish/abandon) and reuses it as `event_id` (answers). One idempotency scheme, no parallel mechanism. | GDM-006/008 |
| `playback_url` contains a random `token` query param pointing at a nonexistent route | The parameter is decorative today and must **not** be treated as authorization. New media byte route: drop the URL token; authorize via child context (browser) or grant (native) + session-asset membership + `no-store`. Tokens never appear in URLs. | GDM-013 |
| No feature-flag mechanism exists | Add one minimal server config flag gating the new module, media route, and native pairing; default off in production builds. Rollback = flag off + grant revocation; no data deletion. | GDM-006 (flag), QA-39 |
| Bootstrap aggregate vs composition | Default: client composes `catalog` + `learning/current` (+`/v1/me`); no new aggregate endpoint unless GDM-003 proves a hard need (keeps backend surface minimal). | GDM-003 |

## Configurable limits (initial engineering values)

| Limit | Initial value | Changed by |
|---|---|---|
| Pairing human code | 8 chars, unambiguous alphabet, hashed at rest | Security-minded engineer + owner review |
| Pairing expiry | 5 minutes | idem |
| Poll interval (client-enforced floor) | 5 s | idem |
| Code-entry failures | 5 / min per parent + network source, bounded per-pairing cap | idem |
| Grant token | 256-bit random, hashed at rest, `aud=rzq-kids-staging`, max 15 min, in-memory client-side | idem (persistence needs a new ADR) |
| Replay/idempotency retention | Existing 24 h (`idempotency.ts`) | Privacy owner if shortened |
| Bridge message limit | 64 KiB JSON, fixed action allowlist | Client engineer + security review |
| Media bounds | Server-side per-asset validation (existing `media_assets`), `no-store`, no credential redirects | Content owner (asset review) + engineer |
| Lesson/session TTL | Existing 24 h (deviation recorded above) | Owner decision |

## Production rejection tests (specified; to be implemented in `rz-quran` security suite)

- **P1** With `APP_ENV=production`, `POST /kids/pairings` and `POST /kids/pairings/token` are not routed (404) or refuse with a neutral error; no pairing row can be created.
- **P2** A token minted by the staging module presented to a production-configured app → 401 before any handler; no profile or session data in the response.
- **P3** `POST /parent/kids/pairings/approve` is unavailable in production; in staging it requires mode `parent` + live gate + ownership + synthetic-profile allowlist.
- **P4** Tampered client asserting a different audience still fails: audience is compared from the **stored grant row**, not client input.
- **P5** Parent logout / profile deletion / grant revoke invalidates the grant for subsequent native calls (401), independent of client state; reuse after "restore backup" is covered by QA-35.

Native flow is **staging-only, synthetic-profile-only** by construction (env-gated module + allowlist). Production native auth, persistent credentials, and refresh tokens are out of scope and require a new ADR.

## Explicitly not covered here

Content rights, curriculum correctness, artwork/audio review (GDM-027), privacy/pilot legal authorization (GDM-028), observed pilots (GDM-029), operational drills (GDM-031), owner acceptance (GDM-032). No signature, participant, or approval is claimed by this document.

## Evidence status

QA-05 is a documented technical review; the P-tests and checklist checks above are **specified, not yet executed**. Implementation and execution follow in GDM-006/007/008/009/010/021 with their own evidence records. Nothing in this review has been executed as a test run.
