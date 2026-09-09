---
type: Evidence Record
title: GDM-008 — browser host bridge with existing auth
description: Bridge validation logic (QA-14/QA-15 logic level), host page, web adapter, and honestly unexecuted browser checks.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-09'
sources:
- resource: /github/issues/GDM-008.md
  title: GDM-008 issue criteria
- resource: /architecture/platform-auth.md
  title: Platform adapters and staging-only native pairing
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-008
---

# GDM-008 evidence (QA-14 + QA-15, logic level)

## Candidate

| Field | Value |
|---|---|
| Backend web app | `rz-quran` — `apps/web/src/kids/bridge-host.ts` (host core), `apps/web/src/pages/kids-godot.tsx` (host page, route `/anak/godot` in child mode), `apiRequest` export |
| Client | this repo — `game/platform/web/web_client.gd` (full JSBridge adapter), rebuilt exports @ build ID `5f25c9c07028-20260908T191321Z`, synced to `apps/web/public/kids-runtime/` (gitignored there) |
| Executor / time | implementation agent (zcode), 2026-09-09 ~02:00–02:30 local (UTC+7) |

## Bridge design (as implemented)

- **Envelope**: `{rzq_bridge:1, protocol_version:"1", request_id, runtime_nonce, action, payload?}` → `{…, ok:true, data?, buffer?}` or `{…, ok:false, error:{code,message}}`.
- **Host validation pipeline** (`validateBridgeMessage`, pure and DOM-free): exact origin → exact source window identity (the registered iframe) → marker/protocol → 64 KiB JSON size → nonce equality → request-id bounds → fixed action allowlist (`bootstrap, start_session, get_session, submit_attempt, finish_session, abandon_session, get_media, exit`) → **exact key-allowlist payload schemas** (foreign fields — e.g. a caller-supplied `url` — reject). Rejected messages are dropped before any dispatch.
- **No adult secrets cross the bridge**: the host performs all fetches (`credentials: same-origin`); the runtime receives only public DTOs and (for media) raw bytes as a transferred ArrayBuffer with MIME metadata. No cookie value, CSRF secret, or token ever appears in a message.
- **Lifecycle**: nonce minted per page load; `dispose()` drops in-flight work — late responses to a disposed host are dropped (tested). `exit` disposes the host.
- **Godot side** (`web_client.gd`): nonce captured from the iframe URL; JS forwarder/listener installed idempotently; responses correlated by request id with a 15 s timeout returning recoverable `NETWORK_TIMEOUT` (never a fabricated answer outcome); media buffers arrive as typed byte arrays; every adapter method is awaitable and returns typed `PlatformClient.Result` values.
- **Server authority**: the host only relays; a server `PARENT_GATE_REQUIRED` (or any 4xx) reaches the runtime as an error envelope. Nothing client-side can bypass parent/ownership checks (QA-15).

## Executed checks

| QA | Check | Procedure | Result |
|---|---|---|---|
| QA-14 | Wrong origin / source window / stale nonce / unknown action / wrong protocol / malformed shape / oversized message all rejected pre-dispatch | `tests/unit/kids-bridge-host.test.ts` (15 tests) | **PASS** |
| QA-14 | Payload allowlists: foreign field (`url`), bad UUIDs, path-like option ids reject | same | **PASS** |
| QA-15 | Relay correctness: bootstrap composed from me+catalog+current; server errors (e.g. `PARENT_GATE_REQUIRED`) relay unchanged; media bytes transferred with transfer-list | same | **PASS** |
| QA-15 | No cookie/CSRF material in serialized bridge traffic; dispose drops late messages | same | **PASS** |
| — | Web app typecheck; client export rebuild + native smoke run (`platform=native-https`); runtime synced same-origin | build log | **PASS** |
| — | Full backend regression: integration 22, contracts 26, unit 15, security 17 | suites | **PASS** |
| QA-14/15 | **LIVE BROWSER ROUND-TRIP (2026-09-09, follow-up)**: real Chrome (Playwright, system Chrome, SwiftShader WebGL2) against the local dev stack — signed-in parent → child mode → `/anak/godot`; the exported runtime booted, sent `bootstrap`, the host validated + dispatched (`/me`, `/catalog`, `/learning/current` all 200) and the runtime received the response; home rendered with live server data (nickname from the session) | `node_modules/rzq-check/rzq-*.mjs` probes (rz-quran worktree) + rendered screenshot | **PASS** (after two real fixes, below) |

## Live-browser fixes (found only because the round-trip was executed)

1. **GDScript Dictionary → JS marshaling**: passing the envelope Dictionary through the `JavaScriptObject` interface call delivered a mangled object that the host rejected (`reject:shape`). Fix: the game serializes to a JSON string and the page-side forwarder parses it before `postMessage`.
2. **`JavaScriptBridge.create_callback` garbage collection**: the callback was referenced only from JS (`window.rzqToGodot`); Godot collected it and host→game responses silently no-op'd. Fix: keep a strong GDScript-side member reference.

Both violate the earlier "logic level" assumption and are now covered by the live run; the unit tests remain green because they test host logic with fake windows, which cannot see engine marshaling.

## Explicitly not executed (honest boundary)

- ~~**No real browser run**~~ — **superseded 2026-09-09**: the live Chrome round-trip now passes (see executed checks). Still open from the original list:
- Safari/Firefox and real mobile browsers untested (QA-31/GDM-019 device matrix).
- Media buffer transfer (`get_media`) has not carried real audio bytes in a live run yet (no audio assets exist).
- The full journey inside the game (start → rounds → finish) awaits GDM-012..015 scenes.
- The dev-mode serving path (Vite dev server vs built static host) has now been exercised for boot+bootstrap via Vite; the built static host path is still unexercised.
