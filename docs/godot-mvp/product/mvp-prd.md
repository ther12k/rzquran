---
type: Product Requirements
title: MVP PRD — shared Godot learning slice
description: The smallest useful browser-and-Android learning flow with measurable acceptance.
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

# MVP PRD

## Product decision

The MVP is **one small learning flow**, not the entire eight-feature product from the earlier mockups. Build a three-item Hijaiyah listening activity with three answer rounds, a result screen, and integration into existing parent reporting. Reuse one Godot scene set for web and Android. Native iOS implementation is deferred, while architecture must not prohibit it.

Primary development outcome: a reproducible, internally testable browser build and Android debug APK at the same commit. Secondary outcome, only with independent approval: a supervised pilot using reviewed materials. Public access and stores are not MVP acceptance targets.

## Users and assumptions

The child-facing UI targets early learners with adult support; exact pilot ages and inclusion criteria require reviewer approval. Do not collect birth dates to implement this assumption. Parents select a profile through existing web controls. Content reviewers and privacy owners keep existing workflows. Engineering tests use synthetic profiles.

The reported existing application includes a backend, parent/admin interfaces, and safety controls. GDM-001 verifies what actually exists. These are reuse assumptions, not validated implementation facts.

## Primary journey

Adult entry/profile selection → child home → listen to three examples → answer three audio-to-letter questions → server-confirmed result → existing parent summary.

On Android, the adult authorizes a short-lived staging grant through the web portal. Pairing cannot grant parent/admin access. On either client, the child can stop without penalty. No timer, leaderboard, lives, daily-pressure streak, microphone, or inferred fluency.

## Functional requirements

| ID | Requirement | Acceptance boundary |
|---|---|---|
| R01 | Safe entry and profile context | Existing adult web auth/parent gates are reused; every child API validates ownership and effective child context. |
| R02 | Shared client | The same Godot lesson scenes run in a real web export and Android debug APK at one commit. |
| R03 | Responsive child home | One lesson card, clear start/resume state, and unobstructed controls at the specified phone/tablet sizes. |
| R04 | Versioned lesson content | Exactly three reviewed letter/audio pairs in learning mode; unsupported/unapproved/recalled packs fail closed. |
| R05 | Listen and practice | Explicit playback/replay, visible playing/loading/error states; no autoplay or overlapping prompts. |
| R06 | Three answer rounds | One server-accepted answer per round; choices are tappable, no drag requirement; feedback is gentle. |
| R07 | Honest completion | Server verifies three accepted answers, records one finish per session, and never labels practice as memorization. |
| R08 | Recovery | Duplicate requests, backgrounding, network loss, expiry, recall, and profile changes follow explicit state rules. |
| R09 | Accessible equivalent | HTML route uses the same content version, server rules, completion semantics, and accessible navigation. |
| R10 | Parent visibility | Existing protected dashboard shows completed sessions, distinct lessons practiced, and first-answer accuracy with a denominator. |
| R11 | Android staging entry | Expiring parent-approved, child-scoped, in-memory native grant; production cannot issue or accept it. |
| R12 | Privacy and governance | No secrets/answer keys in payloads or binaries; no new tracking/permissions; deletion/recall reaches added state. |
| R13 | Reproducible delivery | Version pins, web/Android exports, automated checks, device evidence, artifacts and hashes. |
| R14 | Measured quality | Device-specific performance, audio, rendering and accessibility tests; no transfer of old React measurements. |
| R15 | Honest readiness | Separate tooling, execution, human approvals, observed pilot, remediation, and owner acceptance. |

## Included surfaces

Adult entry/profile selection (reuse); native pairing approval (small protected web addition); child home; example listening; answer round; result; recoverable/terminal states; accessible HTML equivalent; one parent summary card (reuse or minimal extension).

## Success measures

For internal acceptance, the named required paths in [test plan](../qa/test-plan.md) must pass on Android Chrome, iPhone Safari, and an Android native debug build using named physical devices. All three share the same content version and backend rules. No open critical/high security defect or known critical content defect may be hidden by a waiver.

Targets, not measurements: controls at least 48 logical units; supported layout widths 360/390/430/768/1024; first game-ready p75 ≤8 seconds on the agreed test profile; warm game-ready p75 ≤3 seconds; gameplay p95 frame time ≤33 ms; answer API p95 ≤400 ms under the defined load. Exact test conditions and escalation rules are in [test plan](../qa/test-plan.md). If a target fails, record the failure and obtain an explicit scope or budget decision; do not redefine the metric after the run.

Pilot measures are defined before recruitment: independently observed task completion, adult assistance, misleading feedback, difficulty hearing/reading, and exit success. The protocol owner sets sample size and thresholds; the agent does not manufacture them. Three- or five-person anecdotes are not automatically proof of efficacy.

## Non-goals

Surah reading/memorization library, tajwid scoring, voice capture, adaptive AI, all Hijaiyah letters, multi-game catalog, monetization, push notifications, offline synchronization, native parent/admin app, production native login, iOS native build, stores, and public launch. See [scope](scope.md).

## Definition of done

Internal MVP: GDM-001–026 accepted with exact evidence, safe fixtures or approved assets, working feature-flag rollback, no external exposure implied. Learning/pilot readiness additionally requires GDM-027–032 and their actual evidence. A future public launch needs a new decision and backlog.
