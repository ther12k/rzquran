---
type: Reference
title: Project context and authority boundary
description: User-requested direction and reported baseline, without a fresh repository audit.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- resource: User messages and handoff attachments in the RZ-Fiqh project conversation
  title: User-provided requirements, completion report and earlier handoff
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Project context

## User requirements used

The user requested a child-friendly, responsive mobile-first Qur’an learning app with listening/practice, memorization, short surahs, quizzes, Hijaiyah games, parent progress, safety and staged learning. Earlier generated mockups established a soft green/pastel visual direction.

The user subsequently chose both browser testing and future mobile apps, and now asks for an **MVP-first documentation bundle in OKF format, with all issue tasks registerable on GitHub and all Markdown files in a ZIP**. This bundle scopes the first Godot activity rather than implementing all eight product areas immediately.

## Reported existing project

Repository named by the user: `ther12k/rz-quran`. Reported prior SHA: `669c5e3`. The user reported extensive backend/web implementation and tests. Those claims were not revalidated against the repository while creating this bundle; there is no source checkout or fresh CI audit here.

The earlier handoff used React/TypeScript/Vite/Tailwind/shadcn, Bun/Elysia, PostgreSQL/Drizzle, adult auth and private media storage. Treat these as the intended reuse baseline, then inspect. Do not silently require Elysia “2” or any unverified version from older conversation fragments; pin compatible actual dependencies in the repository.

## Earlier artifacts consulted

`RZ-Quran-Kids-Handoff-v1.0.zip` and `RZ-Quran-Kids-All-in-One-v1.1.zip` were available locally for context. The previous material emphasized human approval, content rights, review/publication/recall, ownership, privacy and honest evidence. Its earlier 74-task plan is not reimported or superseded by the new GDM IDs.

The earlier audit discussion specifically separated preflight tooling from operational execution and pilot-driven engineering from human approvals. That distinction is preserved in this task plan.

## Authority order

Actual authorized product/security decisions and repository constraints → this scoped ADR and accepted MVP requirements → detailed contracts/UX → issue acceptance. Screenshots are visual references, not authoritative Arabic, permissions, or metrics. A newly found contradiction must be recorded and resolved, not hidden by an agent choosing an easier criterion.

## Provenance limits

This document paraphrases the user-provided conversation and locally available handoff. It is not a published external source or a verification of GitHub status. New requirements, thresholds, task estimates and designs are proposals. All concepts remain unreviewed until actual review is recorded.
