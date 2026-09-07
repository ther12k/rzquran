---
type: Guide
title: Start here — Godot MVP handoff
description: Read order, delivery boundary, and use of the Markdown-only handoff.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: okf
  resource: https://raw.githubusercontent.com/GoogleCloudPlatform/knowledge-catalog/main/okf/SPEC.md
  title: Google Cloud Platform — OKF specification v0.2
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# RZ Qur’an Kids — Godot MVP

**Build one small child-learning experience for the mobile browser and an Android debug app. Keep the existing backend and React parent/admin areas. Native iOS and public app-store release are later work.**

This is an implementation specification and importable backlog, not application source code or a claim that an app has been built. Every file in this archive is Markdown. UI wireframes, contract examples, and the optional GitHub importer are embedded as fenced text; there are no PDFs, image binaries, font files, APKs, or hidden credentials.

## Start in this order

1. [MVP PRD](product/mvp-prd.md), [scope](product/scope.md), and [gates](product/acceptance-gates.md).
2. [Architecture decision](architecture/adr-001.md), [platform/auth boundaries](architecture/platform-auth.md), and [API contract](contracts/api.md).
3. [UX](design/ux.md), [milestones](delivery/milestones.md), and [issue index](github/issues/index.md).
4. [Agent instructions](AGENTS.md) and [handoff prompt](HANDOFF_PROMPT.md).

To register work, read [GitHub registration](github/README.md). There are **32 new issue documents**: GDM-001–GDM-026 deliver and verify the internal MVP; GDM-027–GDM-032 track a separately gated supervised pilot. They do not replace or renumber the previous T001–T074 backlog. All are proposed and initially open. The importer creates neither assignees nor deadlines, and never closes existing issues.

## What the MVP does

An adult opens the existing authenticated entry point and selects a profile. The child enters a small Godot home screen, listens to three reviewed letter examples, answers three listen-and-select rounds, and sees an honest practice summary. The server validates each answer and the parent sees the result in the existing web dashboard. An equivalent HTML activity remains available. Android uses the same scenes and a staging-only parent-approved pairing flow.

Where approved letter/audio assets are not available, a visibly labeled shapes-and-tones fixture may prove engineering behavior. That does **not** prove a Hijaiyah curriculum works or authorize child testing. No audio or artwork is included in this documentation package.

## OKF and authority

This is an OKF v0.2 knowledge bundle: concept documents have YAML frontmatter and cross-links; `index.md` and `log.md` use their reserved structures.[^okf] [Profile details](references/okf-profile.md) explain the project-specific metadata. OKF organizes documentation; it is not the operational database or a runtime content trust mechanism.

All design decisions are proposals pending owner review. No document contains fabricated human verification. Mechanical package checks are recorded in [package validation](qa/package-validation.md); they do not verify repository behavior. The existing repository and reported commit were not fetched or audited for this package.

## Preserve previous work

Reuse verified auth, ownership, content release/recall, progress, deletion, and parent/admin components. First map actual repository contracts. Add only the missing integration. If the baseline is unavailable or materially different, report the exact gap instead of creating a second backend.

[^okf]: Google Cloud Platform — OKF specification v0.2.
