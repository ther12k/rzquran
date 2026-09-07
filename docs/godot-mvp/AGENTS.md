---
type: Agent Instructions
title: Implementation rules for the Godot MVP
description: Boundaries, evidence requirements, and task execution rules for an implementation agent.
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

# Agent instructions

Read [PRD](product/mvp-prd.md), [scope](product/scope.md), [ADR](architecture/adr-001.md), [API](contracts/api.md), and the assigned issue before changing code. Inspect the actual repository and record the starting SHA. Earlier completion reports are reported context, not current evidence.

## Work boundaries

Implement GDM tasks in dependency order. Begin with GDM-001, GDM-002, and GDM-004. Keep existing React flows working under a feature flag. Do not rewrite auth, the database, parent/admin screens, or content governance without a verified necessity and an owner-reviewed decision. Proposed API paths are a compatibility contract; map them to equivalent existing paths before adding endpoints.

Use shared typed GDScript scenes, platform adapters, and one existing backend. No C#, 3D, LLM/RAG, vector database, ads, social accounts for children, microphone, analytics SDK, offline lesson packs, store submission, or unrelated UI redesign in this MVP.

Do not publish or deploy externally without authorization. A user asking to prepare issue files is not permission to register them in GitHub. GitHub import requires an explicit `--apply` invocation by an authorized operator.

## Safety and truth

The server owns authorization, content validity, answer checks, idempotency, completion, and progress. Never embed answer keys, production secrets, or parent credentials in the Godot package. The browser bridge is not a security boundary. Stage-only native grants must be rejected by production.

Development fixtures are visibly non-production. Do not invent recitations, learning assets, signatures, reviewer identities, legal consent, participants, measurements, or app-store approval. Preserve recall/deletion guarantees. Stop playback and clear session material on logout, profile switch, invalidation, and terminal errors.

## Closure is an evidence decision

For an engineering task: implement its exact acceptance checklist, run its named checks, attach paths/results, and update traceability. A test file or screenshot count is not proof of acceptance. Keep unrun checks explicitly unrun.

GDM-025 is tooling; GDM-026 is the internal execution record. GDM-027/028 are human evidence. GDM-029 is an observed pilot. GDM-030 is engineering blocked on findings. GDM-031 is actual operational preflight. GDM-032 is a human decision. Do not merge these scopes to improve the issue count.

Treat `status: draft` as documentation lifecycle, not issue status. Treat `x_rzq.issue_state` as planning metadata, not a GitHub API field. After issue import, GitHub is the task-state source of truth and the docs record accepted contract changes.

## Every milestone report

Record commit and dirty-worktree state; changed task IDs and files; migrations and compatibility mappings; exact commands and exits; artifact hashes; device/browser/OS details; executed vs unexecuted tests; outstanding gate owners by role; and next dependency-ready tasks. Use [evidence template](qa/evidence-template.md).

Do not commit generated caches, signing keys, private audio, personal pilot data, or temporary import receipts. Do not infer iOS native support from Safari browser tests. Preserve accessible HTML flows where native/web Godot accessibility is insufficient.
