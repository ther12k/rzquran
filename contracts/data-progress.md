---
type: Data Model
title: Minimal data changes and progress semantics
description: Reuse mapping, uniqueness invariants, deletion hooks, and honest metrics.
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

# Reuse before migration

Do not execute a speculative 28-table replacement. Inventory existing tables, constraints, migrations and serializers. Map the conceptual entities below; create only missing columns/entities. Use the repository's existing migration tooling and rollback conventions.

| Concept | Minimal new need, only if absent | Required invariant |
|---|---|---|
| Lesson release | Client compatibility/projection version and existing asset permissions | Immutable current version; recall enforced |
| Learning session | Client platform/build, release pin, expiry, content mode | Owned by one existing profile; no reassignment |
| Answer attempt | Question/option, first correctness, request ID, server time | Unique `(session_id, question_id)` |
| Completion | Existing finish event or equivalent | Unique `session_id` |
| Request replay | Scope, normalized payload hash, committed response reference, expiry | Unique actor/profile + operation/resource + request UUID |
| Staging pairing | Hashed code, challenge, state, expiry, approved profile/parent | One successful redemption; staging only |
| Staging grant | Token hash, audience, profile, lesson allowlist, expiry/revocation | No parent/admin scopes; no raw token storage |

These are conceptual entities, **not seven required new tables**. Existing session/attempt/progress storage should normally be reused. Pairing and grant records may be the only new auth-side structures, depending on the actual repository.

## Transactions

Answer transaction locks/validates the session's current question, validates active ownership/release/grant, inserts one answer, advances server cursor, and commits replay outcome atomically. Finish checks three accepted rounds and inserts one completion. Concurrency tests must exercise conflicting and identical requests, not just sequential retries.

Duplicate completion stays prevented even after short-lived replay rows expire. Request IDs cannot be reused across profiles to disclose stored responses. Replays after recall/deletion re-run access checks and do not return a stale success containing private data.

## Summary definitions

`completed_sessions` counts distinct completed session IDs in the requested server-defined window. `distinct_lessons_practiced` counts distinct lesson IDs among them. `first_answer_correct_count / first_answer_total` aggregates accepted first answers of included completed sessions, with a visible denominator. No-data means “Belum ada latihan selesai,” not 0% fluency. Display completed-session result separately from all-time aggregates.

A repeat session can increase completed sessions but not distinct lessons for the same lesson. An unfinished/abandoned/expired session does not enter completed-session accuracy in this MVP. Retain partial answers only under the existing retention policy; do not silently turn them into completions. Fixture statistics never mix with reviewed-learning/pilot reporting.

Time-on-task, streaks, stars economy and inferred memorization are not MVP metrics. Use server UTC for events and the existing configured display timezone; do not invent a device timezone as authority.

## Deletion and revocation

Profile/account deletion invalidates sessions, pairing approvals and native grants; removes or suppresses attempts/replays according to existing policy; clears client state on the next check. Integrate new stores into exports, deletion jobs, audit redaction, backup restore/suppression and tests. Do not retain token hashes or pairing records forever merely because they are “technical.”

The restore/deletion check in GDM-021 targets any new state. Reuse the existing drill harness, but verify the new grant/replay tables are included. A full new disaster-recovery program is not part of this client extension.

## Migration acceptance

Attach before/after schema mapping, forward migration test, rollback/data preservation strategy and representative query checks. Never apply migrations to an external environment without authorization. Performance figures require actual representative data sizes, not empty-table timings.
