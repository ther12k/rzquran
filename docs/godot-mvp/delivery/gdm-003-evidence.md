---
type: Evidence Record
title: GDM-003 — executable API and content projection contracts
description: Executed QA-03/QA-04 contract tests, fixture inventory, and the cross-repository mapping.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-08'
sources:
- resource: /github/issues/GDM-003.md
  title: GDM-003 issue criteria
- resource: /contracts/api.md
  title: MVP API compatibility contract v1
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-003
---

# GDM-003 evidence (QA-03 + QA-04)

## Candidate

| Field | Value |
|---|---|
| Backend | `rz-quran` — `packages/contracts/src/kids_mvp.ts`, `tests/contracts/kids-mvp.test.ts`, `contracts/examples/kids-mvp/*` (additive; no route changes) |
| Client mirror (this repo) | `contracts/kids-mvp/` — JSON Schema + byte-identical fixtures + [MAPPING.md](../../../../contracts/kids-mvp/MAPPING.md) |
| Executor / time | implementation agent (zcode), 2026-09-08 ~20:45 local (UTC+7) |

## Executed checks

| Check | Command (in `rz-quran`) | Result |
|---|---|---|
| QA-03 valid fixtures pass | `bun run test:contracts` | **PASS** — 3/3 valid fixtures validate against deep-strict projections |
| QA-03 invalid fixtures reject | same | **PASS** — unsupported version, leaked `correct_option_id` in an option, 5 options, leaked answer map, missing asset id all reject |
| QA-03 no answer map in public fixtures | same (`no valid fixture mentions correct_option_id or an answer key`) | **PASS** |
| QA-04 write strictness/bounds | same | **PASS** — extra private/derived fields reject; malformed UUIDs, path-like (`../etc/passwd`), 33-char option ids, 201-char prompts, 60 s heartbeat, and error envelopes with extra keys all reject |
| Regression | `bun run test` (contracts 26, unit 7, integration 13) + `bun run typecheck` | **PASS** — all green; schemas are additive |
| Fixture parity | `cmp` all 8 files client↔backend | **PASS** — byte-identical |

## Design notes

- Public projections are **deep-strict** (`additionalProperties: false` / `z.strictObject`): any extra key — e.g. a `correct_option_id` riding inside an option — fails validation rather than being stripped, so leaks surface in tests instead of passing silently.
- The strict schemas describe the *actual serializer output* of `learning.ts`; no server behavior changed in this task. Strict write-schema adoption at the route layer is wired in GDM-007 (recorded in MAPPING.md).
- Bootstrap is the client-composed shape per the GDM-004 decision; `content_mode` is server-derived from `demo_only` + environment.
- Fixtures are golden files: the Godot parser (GDM-006+) and HTML equivalent must consume exactly these shapes; `kids-mvp.schema.json` is the language-neutral mirror.

## Explicitly not executed

- No live HTTP round-trip test against a running server (contract level only; route-level integration arrives with GDM-006/007).
- Arabic text-direction fixture case from content.md: deferred to GDM-012's rendering checks (schema-level `prompt` is direction-agnostic plain text).
- No client parser implementation yet — GDM-006.
