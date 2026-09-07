---
type: Security Policy
title: Safety, privacy, content and threat checks
description: Project security constraints and bounded mitigations for the new clients.
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

# Safety and threat checklist

These are product/engineering requirements, not jurisdiction-specific legal advice. Preserve the existing policy and use actual privacy/content owners for decisions. No new real-child collection is authorized by preparing this package.

| Threat | Required mitigation | Evidence |
|---|---|---|
| Child invokes adult action | Server parent gate + ownership, not hidden buttons | Unauthorized/child-context integration checks |
| One profile sees another's answers | Effective-profile scope on every query/replay | Cross-profile and enumeration tests |
| Native bundle leaks auth/key material | Public DTOs, binary/source scans, no secrets | Source/export scan + runtime inspection |
| Pairing code guessing/replay | Expiry, limits, verifier proof, explicit approval, one-use redeem | Wrong verifier/code/replay/rate tests |
| Staging credential reaches production | Audience/environment enforcement | Production-mode rejection test |
| Duplicate/tampered progress | Transactions, current-question check, uniqueness, payload hash | Concurrent duplicate/conflict tests |
| Recalled content keeps earning results | Access checks before every sensitive operation/replay | New/read/media/attempt/finish matrix |
| Abandoned session contaminates another profile | Clear buffers/pending state and reject stale IDs | Switch/logout race tests |
| Restore resurrects deleted new state | Include added grant/replay state in existing suppression drill | Restore-and-suppress evidence |
| Arbitrary code/URL from content | Schema limits, text-only render, allowlisted media/actions | Injection/redirect/oversize negative checks |
| Unapproved learning/pilot exposed | Environment/content gate and fail-closed preflight | Missing-evidence test + real evidence separate |

## Data minimization

Reuse minimal profile nickname and opaque IDs. No child email, birthdate, photo, voice, location, contacts, advertising identifier or third-party analytics. Avoid collecting persistent native device IDs. Use transient pairing/build identifiers. Debug screenshots contain only synthetic profile data; redact credentials, pairing codes and request tokens.

Grant credentials never appear in URLs, localStorage, IndexedDB, `user://`, persistent preferences, exported fixtures, client crash reports or server logs. The internal MVP intentionally pairs again after process exit. Any future persistent credential storage requires a new ADR and native security implementation.

## Runtime verification, not scans alone

Inspect browser requests, native traffic in an authorized test setup, permitted logs and successful/error API responses. Verify no prohibited SDK endpoints or unexpected permissions. Static source/export scans are an additional layer, not proof of log and response safety.

Test with synthetic requests that trigger unauthorized access, validation errors, rate limits, pairing, media failures, profile deletion and recalls. Error handling must not echo submitted secrets. Trace IDs are opaque and must not encode identities.

## Content governance

Current source/asset rights, review and recall remain server decisions. Development can use owned abstract fixtures; actual learning mode requires reviewed material. No speech synthesis of recitation, fake Arabic from design images or inferred “passed memorization.” A positive practice result cannot be used as a religious proficiency claim.

## Operational boundaries

No background learning/audio, push notifications, public social functions or paid features. Restrict debug APK access and revoke grants when testing ends. Reuse existing backup/deletion policies, not a new inconsistent retention system. Record the chosen retention and grant cleanup in GDM-004/010.

## Defect severity

Cross-profile disclosure, parent-gate bypass, production acceptance of staging credentials, exposed secrets, invalid-content completion, or a known critical learning-text/audio defect blocks acceptance. Missing test evidence is “unverified,” not “pass.” Performance/accessibility scope exceptions require named owner decisions and an alternative path; security bypasses do not become acceptable by renaming a gate.
