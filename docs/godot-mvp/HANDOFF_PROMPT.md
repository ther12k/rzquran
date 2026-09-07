---
type: Prompt
title: AI agent handoff prompt
description: Copyable implementation prompt for the first safe Godot vertical slice.
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

# Copy this prompt into the implementation agent

```text
Implement the RZ Qur’an Kids Godot MVP from this OKF bundle.

Read index.md, README.md, AGENTS.md, product/mvp-prd.md,
product/scope.md, architecture/adr-001.md, contracts/api.md,
and github/issues/index.md. Inspect the existing repository first.

Deliver a shared 2D typed-GDScript client, mobile-browser first,
plus an Android debug build from the same commit. Preserve React
parent/admin areas and the existing Bun/Elysia/PostgreSQL platform.
Use platform adapters; keep browser-only code out of lesson scenes.

Start with GDM-001/002/004, then follow dependencies. Implement one
three-item listen-and-select lesson, server-validated results,
parent summary integration, and an equivalent accessible HTML flow.
Do not expand into a full child-app rewrite or surah library.

Map the proposed contract to existing endpoints before creating new
ones. Keep profile ownership, parent gates, recall, deletion,
idempotency, and progress authoritative on the server.

Android MVP pairing is restricted to staging and synthetic profiles.
No persistent native login or production native auth is in scope.
If reviewed letter/audio assets are unavailable, use clearly marked
engineering fixtures; do not call fixtures learning-ready content.

Never invent approvals, participants, recitations, measurements, or
completed tests. Preserve all original safety and release gates.
GDM-001–026 cover the internal MVP; GDM-027–032 are a separate,
conditionally authorized supervised pilot. Do not close execution
or approval tasks merely because a checker exists.

For each milestone, report exact tasks, changes, commands/results,
web and Android artifacts, device evidence, hashes, unexecuted
checks, and blockers. Do not claim native iOS testing unless run.

Begin with repository assessment, contract gaps, and a short plan,
then implement the first dependency-ready safe slice. Do not deploy
externally or register GitHub issues without authorization.
```

For issue registration rather than implementation, use [GitHub registration](github/README.md). The importer defaults to a no-network dry run.
