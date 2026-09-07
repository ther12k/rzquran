---
type: Validation Report
title: Package validation and known limits
description: Actual structural/importer checks, separately from unexecuted application acceptance.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:58:20Z'
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  check_scope: Mechanical package checks and fake-API importer tests only
---

# Package validation — executed in the authoring environment

Checked on 2026-09-07. This report records packaging work, not application implementation or human acceptance. It does not mark the product specification human-reviewed.

## Results

| Check | Executed result |
|---|---|
| Archive payload | 76 UTF-8 Markdown files only; no source app, APK, PDF, images, fonts or standalone scripts |
| OKF structure | 64 concept documents parsed with YAML and nonempty type; 11 reserved indexes plus one dated log checked |
| Metadata/source/footnotes | Required project fields, timezone-qualified timestamps, local source targets and named footnote/source mappings checked |
| Internal links | All inspected non-code Markdown file links resolve inside the bundle |
| Task records | 32 unique IDs, matching frontmatter/manifest, per-file SHA-256 and three acceptance criteria per issue |
| Dependency graph | Acyclic; all references resolve; GDM-026 prerequisite closure contains exactly the 26 internal tasks |
| Traceability | All 15 requirements and 46 planned QA IDs have task mappings |
| Embedded JSON | Nine JSON fences parse successfully |
| Contract fixtures | Nine schema definitions checked; all eight valid/invalid cases match expectations with JSON Schema 2020-12 format checking |
| Embedded importer | Python code compiles and matches the tested helper source |
| Local dry run | Runs without GitHub CLI or network access; internal-only selection plans exactly 26 tasks |
| Fake-API importer tests | 13 tests passed; no live GitHub operations |
| Final ZIP | CRC integrity, entry paths, Markdown-only payload and exact byte-for-byte extracted file comparison checked |

## Importer behaviors actually tested

1. Default offline plan cannot call the API.
2. Internal-only selection expands to the intended 26 prerequisites.
3. Fresh import creates 32 issue records, 12 labels and 5 milestones in the fake API with resolved dependency/source links.
4. Rerun preserves existing closed/edited issues and label definitions without new writes.
5. Simulated response loss after remote creation is reconciled on rerun without duplicates.
6. An unmarked existing known task title blocks registration.
7. Duplicate known markers block registration.
8. Pull requests are ignored when discovering existing issues.
9. A local/committed document-tree mismatch prevents writes.
10. An issue-source hash change is rejected.
11. Dependency cycles and unknown selections are rejected.
12. Unsafe/missing local paths and invalid repository-relative doc paths are rejected.
13. Conflicting marker/title IDs are rejected.

The packaging harness used a temporary authoring workspace with Python, PyYAML and jsonschema. The shipped importer itself needs only Python standard library plus authenticated GitHub CLI for authorized writes. Temporary harness scripts are not required to read this bundle and are not application deliverables.

## What these checks do not establish

No live repository checkout/inspection, API integration, Godot editor run/export, browser/native gameplay, physical-device performance, accessibility result, Arabic/audio approval, participant pilot, or release decision was performed while producing this ZIP. The 46 application/acceptance checks are planned checks, not passed tests.

The fake API tests cover importer behavior and failure handling, not actual GitHub account permissions or every real API failure. Run the local plan first. Use one importer at a time; marker deduplication is not an atomic lock. Native GitHub dependency relationships, Projects boards and existing-body synchronization are not implemented.

Structural checks target the published OKF conventions and additional local consistency rules; this is not third-party certification. No review signatures or `verified: human:...` records were generated. Content correctness and legal authorization cannot be supplied by a YAML validator.
