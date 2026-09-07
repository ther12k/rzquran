---
type: Test Plan
title: MVP verification matrix and performance protocol
description: Forty-six planned checks spanning engineering, devices and external acceptance.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
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

# Test plan

**Every application check below is planned, not executed by this documentation author.** Use the task's IDs, commit/build/content identifiers and actual result. “Not run,” “blocked,” “failed,” and “passed” are distinct. Human review/observation rows are acceptance checks, not automated tests.

## Device matrix

Required internal MVP: a named physical Android phone in Chrome; a named physical iPhone in Safari; and a native debug APK on a named physical Android phone. Record model, OS/browser versions, display settings, connection, and accessible interaction used. Development emulation at 360/390/430/768/1024 widths supplements these checks; it does not replace them. Native iOS is deferred.

For web/HTML, check keyboard/focus, screen-reader instructions/status, 200% text zoom, reduced motion, landscape and changing safe area. Test canvas behavior separately and record its limits. Godot's documented screen-reader support has platform qualifications; do not assume mobile/web equivalence.[^a11y]

## Planned checks

| ID | Area | Procedure | Expected evidence/oracle |
|---|---|---|---|
| QA-01 | Baseline | Record actual SHA/routes/middleware/schema; compare proposed contract mapping. | Every reuse/gap entry links to inspected evidence; unknowns remain explicit. |
| QA-02 | Exports | Export and open the minimal shared project on web and Android. | Same commit; matching pins; artifacts exist; shared scenes compile without web dependencies on native. |
| QA-03 | Schemas | Validate public DTOs and write fixtures, including extra private keys and incompatible version. | Valid fixtures pass; invalid/extra fields reject; no answer map leaks. |
| QA-04 | Input bounds | Send malformed IDs, large strings/arrays, HTML-like text and oversized payloads. | Bounded validation; text not executed; stable non-sensitive errors. |
| QA-05 | Threat review | Walk auth/bridge/pairing/retention/production boundaries with documented attack cases. | Technical review resolves controls; external approvals remain separate. |
| QA-06 | Content modes | Run fixture mode, missing learning pack, unapproved pack and unsupported schema. | Visible fixture badge; no automatic promotion; no-content state is honest. |
| QA-07 | Ownership | Read/start/abandon sessions under another profile/account or child context. | Neutral access failure; no leaked profile/resource status. |
| QA-08 | Release state | Use unpublished, recalled, expired and wrong-release session resources. | No start/media/answer/finish success under invalid state. |
| QA-09 | Media | Request a foreign asset, corrupted/oversized media and unauthorized redirects. | Membership enforced; size/type bounded; no arbitrary credential forwarding or fake audio. |
| QA-10 | Idempotency | Send identical answer/start/finish requests concurrently and replay later. | One mutation; same logical response; no extra completion. |
| QA-11 | Replay conflicts | Reuse request key with a changed choice/profile; test after recall/deletion. | 409 conflict or access failure; no cached cross-profile/private success. |
| QA-12 | Question sequence | Submit a future/foreign question or option; answer twice with distinct keys. | Reject invalid/order/duplicate round; current cursor remains consistent. |
| QA-13 | Completion | Finish early, finish complete session twice, replay after replay-row expiry. | Three accepted rounds required; durable uniqueness prevents extra completion. |
| QA-14 | Bridge protocol | Send wrong source/origin/nonce/action, oversized data and arbitrary URL payloads. | Rejected before host dispatch; no arbitrary request/evaluation. |
| QA-15 | Parent boundary | Invoke parent summary/approval from child context and tamper host requests. | Independent server parent/ownership/CSRF controls hold; no cookie secret exported. |
| QA-16 | Pairing | Create challenge, approve owned synthetic profile, redeem with verifier. | One bounded grant; no profile data before approval; no refresh token. |
| QA-17 | Pairing abuse | Test wrong code/verifier, replay, denial, expiry, poll flood and lost redemption response. | Neutral rejection/rate delay; one-use redemption; restart pairing when receipt lost. |
| QA-18 | Native grant | Replay staging credential at production, revoke parent/profile, restart app, inspect storage. | Production rejects; invalidation holds; no persistent token or extra permissions. |
| QA-19 | Migrations | Apply forward migrations on representative test data and exercise planned rollback. | No unrelated data loss; minimal additions; actual schema mapping documented. |
| QA-20 | Cleanup | Expire pairings/grants/replay rows and delete a profile in new state. | Bounded retention and linked deletion; no raw secrets retained. |
| QA-21 | Responsive shell | Render small/large phone and tablet/landscape with changing safe areas. | Start/exit/answer controls visible and at least project minimum size. |
| QA-22 | Glyphs/options | Render fixture and intended Arabic samples with chosen font at target scales. | No clipping/reversal; final review not presumed; selection is not color-only. |
| QA-23 | Audio | Tap listen/replay rapidly; test decode failure and bounded loading. | Explicit start, one player, clear errors and no overlapping instructional prompts. |
| QA-24 | Audio lifecycle | Pause, lose focus, switch profile, recall release and resume playback. | Audio stops; buffers clear; revalidate before next playback. |
| QA-25 | Round flow | Exercise three correct/wrong rounds with delayed/failed answer responses. | Server-derived state; no optimistic advancement; one accept per round. |
| QA-26 | Result | Delay/fail finish; repeat lesson; inspect wording and counts. | No false success; numerator/denominator correct; practice not mastery. |
| QA-27 | Ambiguous network | Drop response after server commit; reconnect/retry same request ID. | Recover recorded result without duplicate write or false incorrect answer. |
| QA-28 | Switch/races | Switch profile/logout while requests complete; background/resume/kill app. | Stale callbacks ignored; previous private content cleared; no offline queue persistence. |
| QA-29 | HTML equivalence | Complete same release with keyboard, screen reader, zoom and reduced motion. | Same learning objective/server semantics; labels/focus/status usable; no dual-session confusion. |
| QA-30 | Parent metrics | Mix web/native, repeat lesson, partial/fixture sessions and different parent requests. | Shared definitions; separated fixture scope; ownership; no-data not misleading 0% fluency. |
| QA-31 | Web integration | Load actual HTTPS export; break an engine file/capability; exit runtime. | Actual game works; accessible fallback; no handlers/audio left running. |
| QA-32 | Android integration | Install debug APK and run pairing-to-parent-summary on a physical phone. | Complete same-SHA journey; permissions/lifecycle recorded; no editor-only substitute. |
| QA-33 | Runtime leakage | Inspect success/error responses, logs and authorized network traces; scan source/PCK/APK. | No tokens/private keys/trackers; scans and runtime evidence separately recorded. |
| QA-34 | Recall surface | Recall between bootstrap/start/media/answer/finish/replay and resume. | Applicable server calls fail closed; new media denied; delivered-byte limitation stated. |
| QA-35 | Restore suppression | Restore older test backup containing deleted profile and added grant/replay state. | Independent suppression workflow removes/revokes new state before access resumes. |
| QA-36 | CI | Run deterministic client/backend tests and both exports at candidate SHA. | Real commands/results/artifacts; failures block; hardware tests separately tracked. |
| QA-37 | Physical matrix | Run named Android Chrome, iPhone Safari and Android APK device checks. | Required layouts/audio/interruptions/a11y results exist; native iOS remains out of scope. |
| QA-38 | Performance | Run the cold/warm/frame/API protocol below with raw measurements. | Against declared budgets; distribution/sample/workload given; no inherited React claims. |
| QA-39 | Readiness tooling | Provide missing/invalid gate evidence; toggle rollback and production pairing mode. | Fail closed; previous route retained; progress preserved; no fabricated acceptance. |
| QA-40 | Internal execution | Run complete internal acceptance and rollback for the exact candidate. | Real required paths pass or blockers explicit; learning/pilot readiness not inferred. |
| QA-41 | Human asset review | Obtain actual rights/rendering/audio decisions for exact hashes. | Real authorized evidence scoped to distribution/environment, not a generated approval. |
| QA-42 | Human pilot authorization | Obtain actual protocol/privacy/participant decisions before recruitment. | Defined thresholds, consent/withdrawal/data handling; no invented sufficiency. |
| QA-43 | Observed pilot | Facilitate authorized sessions and document observations. | Real de-identified findings with build/content context; simulations not counted. |
| QA-44 | Pilot remediation | Disposition actual findings, fix and rerun affected/critical paths. | Every finding resolved or explicitly accepted at permitted severity; regression evidence. |
| QA-45 | Operational execution | Run candidate-specific restricted-pilot preflight and safety/rollback drills. | Prerequisites current, execution actual, contacts/rollback verified; tooling is not substitute. |
| QA-46 | Owner decision | Present packet and obtain genuine scoped owner decisions. | No absent/denied approval treated as pass; public/store/native-iOS claims excluded. |

## Performance protocol: targets, not results

Before the first recorded run, commit the device list, test routes, fixture/approved asset sizes, backend/database size and benchmark script. Use at least 10 cold and 10 warm browser runs per named phone. For cold runs, clear the project's runtime/cache and record whether OS/network caching remains; for warm runs keep the intended cache. Use a controlled 10 Mbps down / 2 Mbps up / 100 ms RTT profile where tooling permits, and explicitly record any real-network deviation. Avoid simultaneously introducing CPU throttling without naming it.

Measure navigation-to-host-ready separately from navigation-to-**game-ready** (current examples visible, controls enabled, first authorized audio available). Initial targets: game-ready p75 ≤8 s cold, ≤3 s warm. Target total compressed cold transfer ≤20 MiB including engine, pack and initial assets. These targets require validation; do not preannounce them as Godot characteristics.

Record frame times over a 3-minute active scripted scenario: initial target p95 ≤33 ms, with pauses/loading excluded only when clearly labeled in raw traces. Measure tap-to-audible playback separately on actual devices; initial target ≤250 ms after the current asset is ready. Cold download time is not hidden inside the warm playback metric.

For API latency use an owned staging/test environment: 50 concurrent synthetic users, 60 s warmup then 5 minutes of mixed authorized reads (50%), answer writes (30%) and start/finish operations (20%) with enough valid sessions/rounds. Respect the actual three-round model; do not manufacture impossible traffic or treat expected invalid requests as successful throughput. Initial p95 target ≤400 ms for application JSON operations, unexpected error rate <1%. Report achieved request rate, request counts, p50/p95/p99, errors, database size, build and hardware. Media download is measured separately.

Label browser interaction performance as **laboratory evidence**. No child tracking SDK is introduced for these tests. A failed target creates a defect or a documented owner-approved budget/scope change; the original failed result remains in the evidence.

## Visual evidence

Capture U04/U05/U06/U07/U08 and key error states at phone sizes; include pairing and parent summary where relevant. Record each screenshot's viewport and build, rather than counting files as acceptance. Pilot screenshots or recordings with real children require separate authorization; default is synthetic visuals only.

## Automation boundary

Contract/unit/scene/API tests can run automatically. Editor import/export success is not gameplay acceptance. Browser canvas screenshots are not semantic assertions. Device audio, assistive technology, human curriculum and real usability observations require their actual form of evidence. Use explicit test hooks only in controlled test builds and do not export answer keys to public runtime output.

[^a11y]: Godot — DisplayServer accessibility support.
