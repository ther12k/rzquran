---
type: Scope Definition
title: MVP scope and deferred work
description: Limits for this incremental extension and a non-imported future roadmap.
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

# Scope fence

| Now: internal MVP | Conditional supervised pilot | Later; not a GitHub issue in this bundle |
|---|---|---|
| One home + one three-item lesson | Approved real Hijaiyah pack | Full Hijaiyah curriculum and progression map |
| Listen, select, feedback, finish | Human curriculum/audio/font review | Surah memorization and additional games |
| Existing parent/admin/web auth | Authorized participant protocol | Production native identity and persistent sessions |
| Staging-only Android pairing | Actual observations and remediation | Native iOS exports/device testing |
| Web export + Android debug APK | Candidate-specific operational preflight | App Store / Play submission and policy work |
| Equivalent accessible HTML activity | Named owner acceptance | Offline content, caching and sync |

The first deliverable is not a fresh 74-ticket rebuild. Tasks with equivalent existing code require mapping and integration evidence, not duplicate implementation. A completed old issue does not automatically complete a new-client test.

## Content modes

`fixture` is engineering-only and visually labeled on every surface. Use original geometric shapes and short non-speech sounds or existing explicitly permitted test materials. No real profile data. A fixture result stays in a staging dataset and is labeled simulated in the parent view.

`reviewed_learning` uses a current release with provenance, usage rights, Arabic/audio review, and permitted environment. Internal asset approval and pilot/public permission are distinct. A production-looking UI must not hide the fixture badge.

Switching modes requires a server-controlled configuration and valid release; never infer learning readiness from a local JSON flag. Client-side toggles are not authority.

## Compatibility with earlier handoff

Keep its security/content/privacy constraints and unresolved human gates. The new ADR narrowly replaces HTML-only child rendering for this one activity with shared Godot plus HTML equivalence. The old backlog and reviews remain historical; this bundle neither closes nor reopens them. Repository reconciliation belongs to GDM-001.

## Scope-change trigger

A request for more content, offline play, persistent native sessions, full Godot navigation, stores, or a new public pilot changes scope. Record the owner decision, consequences, new issue IDs and acceptance requirements before implementing. Do not smuggle these into a “small UI task.”
