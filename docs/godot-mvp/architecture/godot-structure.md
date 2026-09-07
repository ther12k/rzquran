---
type: Implementation Design
title: Godot project structure and state machine
description: Scenes, services, adapters, and explicit state transitions.
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

# Suggested structure

Adapt the top-level directory to the actual repository; preserve these separations.

```text
apps/kids-godot/
  project.godot
  export_presets.cfg
  scenes/entry/          pairing + loading + feature unavailable
  scenes/home/           one lesson card
  scenes/lesson/         examples, question, feedback, result
  scenes/shared/         buttons, banner, audio control, errors
  services/             LessonService, AudioService, SessionStore
  platform/web/         host bridge implementation only
  platform/native/      HTTP + staging pairing only
  theme/                permitted UI assets and layout resources
  tests/                unit and scene test runners
```

Export presets contain configuration, never signing credentials. Ignore engine import caches, temporary downloads, build output and local tokens. A tiny composition root chooses the platform adapter; scenes depend on a typed application-service interface.

## Service contract

```text
PlatformClient.bootstrap()
PlatformClient.start_session(lesson_id, request_id)
PlatformClient.get_session(session_id)
PlatformClient.submit_attempt(session_id, question_id, option_id, request_id)
PlatformClient.finish_session(session_id, request_id)
PlatformClient.abandon_session(session_id, request_id)
PlatformClient.fetch_media(session_id, asset_id) -> bytes + MIME + checksum
PlatformClient.exit()
```

Results are typed success/error values, not unvalidated dictionaries propagated into UI code. Reject incompatible contract versions. Timeouts return recoverable network states; they do not fabricate answer failures or success.

## Lesson states

```text
BOOT -> AUTH_REQUIRED | LOADING_HOME -> HOME
HOME -> STARTING -> EXAMPLES -> QUESTION
QUESTION -> SUBMITTING -> FEEDBACK -> QUESTION | FINISHING
FINISHING -> RESULT
any active state -> PAUSED_REVALIDATING -> prior valid state
any active state -> NETWORK_RETRY | EXPIRED | RECALLED | EXITED
```

Examples never count as correctness. Each round accepts one answer; feedback can replay the approved prompt but a retry for the same HTTP request keeps the original idempotency key. A new learning attempt is a new session, not rewriting prior correctness.

On wrong feedback, say “Belum tepat. Yuk, dengarkan lagi.” Offer replay and continue; no life penalty. On final completion, show three answered rounds and first-answer correctness only after finish acknowledgement. The result never says “hafal,” “mahir,” or “sudah lancar.”

If a request times out after sending, preserve the same key and refetch/retry. When server state shows the round already committed, display that recorded result. Never advance twice. An expired or recalled session is terminal; don't silently restart and merge results.

## Audio lifecycle

One player at a time; stop the previous sample before starting another. An explicit tap starts audio. Buffer only the current small permitted set in memory; impose size/duration bounds. Stop and clear bytes on invalidation, exit or profile switch. Revalidate before replay after resume; do not keep playing in the background. Browser-specific playback handling lives behind AudioService/platform code, not in scene logic.

## Test seams

Inject fake transport/clock for deterministic scene tests. Keep production validation on the server. A test-only fixture may provide answers to its isolated runner, but never export private test answer metadata in a learning-mode payload or production/runtime bundle.
