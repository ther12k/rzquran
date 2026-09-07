---
type: Evidence Record
title: GDM-001 — rz-quran baseline inventory and contract mapping
description: Inspected facts versus reported claims, proposed-API operation mapping, placement and rollback.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-07'
sources:
- resource: /contracts/api.md
  title: MVP API compatibility contract v1
- resource: /architecture/adr-002.md
  title: ADR-002 — dedicated MVP client repository
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-001
---

# GDM-001 — Baseline inventory (rz-quran @ `f1b43db`)

Executed as part of [GDM-001](../github/issues/GDM-001.md) / QA-01. Facts below were inspected directly in the repository on 2026-09-07; the session transcript and generated bundle were **not** treated as evidence.

## Candidate

| Field | Value |
|---|---|
| Backend repository | `/home/ther12k/Workspace/Learning/islam/rz-quran` (GitHub `ther12k/rz-quran`) |
| Backend commit | `f1b43db66602771cdca88a83aa22b1eb2e1968bd` (branch `main`, `origin/main` in sync) |
| Backend worktree | Clean (`git status --short` → 0 entries) |
| Reported prior SHA `669c5e3` | Present in history (verified: `git cat-file -t 669c5e3` → commit) |
| Client repository (this doc) | `ther12k/rzquran`, `main` |
| Executor / time | Implementation agent (zcode), 2026-09-07 ~20:30–20:35 local (UTC+7) |

## Method

`git log`/`git status`; file-tree walk of `apps/`, `packages/`, `contracts/`, `database/`; direct reads of `apps/api/src/index.ts`, `auth.ts`, `idempotency.ts`, `modules/context.ts`, `modules/learning.ts`, `modules/reporting.ts`, route greps over all modules; schema-table and Zod-DTO greps; `packages/database/migrations/` listing; `package.json` scripts; re-execution of the four Vitest suites (below). **Not** re-executed this pass: Playwright E2E, production build, device checks.

## Inspected facts

### Stack and app shape

- Bun monorepo: `apps/api` (Elysia), `apps/web` (React+Vite), `packages/contracts` (Zod DTOs), `packages/database` (Drizzle). No Redis, queue broker, or second datastore. Migrations: `0000`–`0003` (drizzle-kit).
- Entrypoint mounts six modules under one Elysia app: `identity`, `families`, `learning`, `reporting`, `admin`, `privacy` (`apps/api/src/index.ts:91-96`). Domain routes live under `/api/v1/*`; Better Auth serves `/api/auth/*`.
- Production boot refuses without SMTP configured and other readiness checks (`index.ts:30-33`, `check-production-readiness.ts`).

### Identity, gate, child mode (R01 reuse confirmed)

- Adult-only Better Auth 1.7.2, email+password, **required email verification**, 7-day sessions, CSRF check enabled (`auth.ts`).
- Every domain request resolves server-side context: session → parent row → per-browser-session `session_controls` row carrying `mode` (`parent`/`child`), `activeChildId`, `adultGateUntil` (`modules/context.ts:28-114`). No client-supplied parent/child ID is trusted anywhere.
- `requireParentGate` = mode `parent` + live 5-minute gate (`context.ts:125-134`). `requireChildSessionDb` = mode `child` + owned active child + effective family/child consent + verified email (`context.ts:140-164`).
- Parent gate endpoints `POST/DELETE /api/v1/parent/gate` re-verify the password server-side against the credential hash (`auth.ts:81-98`, `identity.ts:86-147`). Child entry: `POST /parent/children/:childId/enter` (`families.ts:204`).

### Learning engine (inspected semantics)

- `GET /api/v1/catalog` — published lessons with per-child unit progress, search/filter, stage-DAG lock + parent overrides (`learning.ts:148-237`).
- `POST /api/v1/learning/sessions` — version-pinned session; **one active/paused session per child**; same-lesson start returns the existing session; different lesson → `SESSION_IN_USE` (`learning.ts:327-377`). Session TTL **24 h** (`SESSION_TTL_MS`, `learning.ts:15`).
- `GET /learning/sessions/:id` — owner-scoped (childId equality in WHERE, `learning.ts:378-389`).
- `POST /learning/sessions/:id/events` — ordered, idempotent event batch (`unit_acknowledged`, `heartbeat`, `paused`, `resumed`); contiguous sequence check; replay by event-id + payload hash; row-locked transaction (`learning.ts:390-516`).
- `POST /learning/sessions/:id/answers` — **first answer per question stands**; same `event_id` replays the stored result; a *different* event for an answered question returns the stored first answer (`first_response: false`), not a second score; `correct` boolean returned to the child client post-commit (`learning.ts:517-641`).
- `POST /learning/sessions/:id/finish` — requires **all required units acknowledged**; idempotent completion replay; one first-completion star via unique reward insert (`learning.ts:642-727`).
- Recall/expiry integration: session statuses `active/paused/completed/expired/replaced/recalled`; `CONTENT_RECALLED`, `SESSION_EXPIRED`, `SESSION_REPLACED` fail closed (`learning.ts:407-411, 533-536`).
- Transport idempotency: `Idempotency-Key` header (UUID), actor-scoped (`child:<id>` / parent), method+route keyed, request-body SHA-256, stored response, 24 h retention, `IDEMPOTENCY_CONFLICT` on payload mismatch (`idempotency.ts`). Applied to session start, finish, and parent writes; the answer route relies on `event_id` replay instead.
- Error envelope `{error:{code,message,request_id,details}}` for every `ApiError` (`index.ts:51-58`) — same shape as the proposed contract.

### Content, media, privacy

- Content lifecycle exists: `content_sources`, `media_assets` (status `verified` gate), `content_reviews`, `curriculum_releases`, `content_reports`; admin publish/recall routes (`admin.ts`); recall marks sessions `recalled`.
- **`GET /api/v1/media/:assetId/playback` returns `playback_url: /api/v1/media/stream/<id>?token=…` (`learning.ts:309`) but no route serves `/media/stream/*` anywhere in `apps/api/src`** (grep across modules). Media delivery is therefore an honest-unavailable state today (the seeded demo lesson has no audio assets). This is a real gap for R05, not a paper mismatch.
- Privacy: withdrawal, export jobs, child deletion with suppression ledger + `check-suppression` (`privacy.ts`). New grant/replay state must be added to the deletion/suppression path (feeds GDM-010).
- Parent progress `GET /api/v1/parent/children/:childId/progress` (parent-gated, owner-scoped, zero-honest): lessons completed with denominator, per-lesson unit fractions, first-answer accuracy numerator/denominator (null when empty), daily buckets (`reporting.ts`).

### Facts that differ from the bundle's *reported* assumptions

| Bundle assumption | Inspected reality | Impact |
|---|---|---|
| "Reported prior SHA `669c5e3`" | Confirmed present; `main` has moved to `f1b43db` ("v1.1 acceptance reconciliation") | Use `f1b43db` as baseline |
| Lesson cap of 15 minutes (proposed contract) | Existing TTL is 24 h | Decision needed (GDM-004): add 15-min cap for kids sessions or keep 24 h for MVP |
| Native grant/pairing endpoints | **Nothing exists** — no token auth outside Better Auth cookies; no `/kids/*` namespace | Full new staging-only module (GDM-008/009); largest backend addition |
| `client_request_id` in JSON body | Convention is `Idempotency-Key` header (+ `event_id` body field for answers) | Map header→existing mechanism; do not add a parallel scheme |
| `QUESTION_ALREADY_ANSWERED` 409 | First-answer-wins replay response (`replayed`/`first_response` flags) satisfies the same intent | Accept deviation or add 409 for *changed-option* resubmissions (GDM-007) |
| Completion = "three accepted answers" | Completion = required units *acknowledged*; answers scored separately | 3-round fixture lesson works if client sends `unit_acknowledged` after each accepted round; simplest mapping keeps existing semantics |
| Feature flag for rollback | No flag mechanism exists (grep: none) | Introduce a minimal server/host flag as part of integration tasks |
| 12 proposed operations | 6 map to existing routes, 2 partially, 4+ have no counterpart | See mapping below |

## Proposed → existing operation mapping

| Proposed operation | Existing evidence | Status | Gap / scope impact |
|---|---|---|---|
| `GET /kids/bootstrap` | `GET /catalog` + `GET /learning/current` + `GET /v1/me` | Partial | No single aggregate; no `contract_version`/`content_mode` fields. Compose client-side (no backend change) or add thin aggregate. Decide in GDM-003/006 |
| `POST /kids/sessions` | `POST /learning/sessions` | Exists | Idempotency via `Idempotency-Key` header; `SESSION_IN_USE` rule; response shape differs (units, not 3 examples) |
| `GET /kids/sessions/{sid}` | `GET /learning/sessions/:id` | Exists | Shape adapter only |
| `POST /kids/sessions/{sid}/attempts` | `POST /learning/sessions/:id/answers` | Exists | `event_id` idempotency; first-answer-wins replay; `next_question` obtained by re-fetch session |
| `POST /kids/sessions/{sid}/finish` | `POST /learning/sessions/:id/finish` | Exists | Requires acknowledged units (client sends after each accepted answer); star + practice-fraction response instead of `first_answer_correct_count` (derivable) |
| `POST /kids/sessions/{sid}/abandon` | *(none; parent has `POST /parent/children/:childId/replace-session`)* | **Gap** | Child-initiated abandon needed, else one-active-session rule blocks re-entry after exit. Small new owner-scoped route (feeds GDM-007) |
| `GET /kids/sessions/{sid}/media/{asset_id}` | `GET /media/:assetId/playback` → dangling `/media/stream/*` | **Gap** | No byte-serving route; no session-membership scoping. Real backend work + audio asset pipeline use (GDM-013/006) |
| `GET /parent/profiles/{profile_id}/practice-summary` | `GET /parent/children/:childId/progress` | Exists | Profile ≡ child; add per-lesson practice card in existing dashboard (GDM-018), no new endpoint required |
| `POST /kids/pairings` | *(none)* | **Gap** | New staging-only pairing module; rate limits; code hashing (GDM-009) |
| `POST /parent/kids/pairings/approve` | *(none)* | **Gap** | New protected web route reusing parent gate + ownership (GDM-009) |
| `POST /kids/pairings/token` | *(none)* | **Gap** | Challenge/verifier redemption, one-use, audience-bound grant (GDM-009) |
| `POST /kids/grants/revoke` | *(none)* | **Gap** | Grant revocation + hooks into logout/profile deletion (GDM-009/010) |

## Placement and rollback (per ADR-002)

- Client code and exports: **this repository**, root-level Godot project; the bundle stays under `docs/godot-mvp/`. No `apps/kids-godot/` inside rz-quran (ADR-001's suggestion, superseded by ADR-002).
- Backend additions stay in `rz-quran` as **additive** modules (new `native`/`kids-support` module mounted in `index.ts`, new migration `0004+`), plus the missing media byte route and one abandon route. No edits that change existing route behavior; existing React flows untouched.
- Rollback: unmount/disable the new module + media route via a server flag; revoke staging grants; the Godot web route is withdrawn by not serving the new static path — the existing React child route (`lesson-player.tsx`, `child-home.tsx`) is the retained fallback. Server progress data is preserved (rollback never deletes rows).
- Old T001–T074 backlog (`tasks/`, `docs/m5/ACCEPTANCE_MATRIX.md`) is neither renumbered nor closed; GDM is a separate namespace.

## Evidence

| Check | Command (in `rz-quran`) | Result |
|---|---|---|
| Contracts suite | `bun run test:contracts` | **PASS** — 1 file, 9 tests (2026-09-07 ~20:31 local) |
| Unit suite | `bun run test:unit` | **PASS** — 1 file, 7 tests |
| Integration suite (PostgreSQL 16, Docker `rzq-kids-db`, up 24 h) | `bun run test:integration` | **PASS** — 4 files, 13 tests |
| Security suite | `bun run test:security` | **PASS** — 3 files, 17 tests |
| Dependency install | `bun install` (per committed `bun.lock`; worktree stayed clean) | 208 packages, exit 0 |

Explicitly **not executed** this pass: `bun run test:e2e` (Playwright), `bun run build`, performance protocol, device checks — out of QA-01 scope; remain with their owning tasks (QA-31/32/36/38).

## Unknowns / open for later tasks

- Whether `/v1` should become an alias prefix or the client targets `/api/v1` directly (proposed paths are a compatibility contract, not literal requirements) — GDM-003.
- 15-minute lesson cap vs 24 h TTL — GDM-004.
- Bootstrap aggregation choice (client-composed vs server endpoint) — GDM-003/006.
- Fixture lesson seeding strategy for the 3-round shape-and-tones activity (existing `db:seed:demo` seeds a 2-letter demo lesson) — GDM-003/005.
