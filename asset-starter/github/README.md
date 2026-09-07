---
type: Asset Specification
title: Asset task registration and existing-task mapping
description: Asset task registration and existing-task mapping.
tags:
- rz-quran-kids
- godot-mvp
- assets
status: draft
generated:
  by: chatgpt/rzq-asset-starter-1.1
  at: '2026-09-07'
sources:
- resource: ../../mvp-docs/contracts/content.md
  title: Original MVP content contract; preserved unchanged in companion bundle
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Asset task registration and existing-task mapping

Three proposed issue bodies are supplied in [issues](issues/index.md). They are asset subtasks/addenda, not replacements for the original 32 GDM tasks. No issues have been created, updated or closed.

| New ID | Relationship | Default |
|---|---|---|
| GDA-001 | Supports GDM-011 and GDM-013 | Proposed asset integration subtask |
| GDA-002 | Supports child UI polish | Optional for internal MVP; required only if adopted for a release |
| GDA-003 | Supports GDM-023 and GDM-024 | Proposed asset verification subtask |

The original importer consumes its own fixed GDM manifest. These three files are **not** automatically understood by that importer. Review and register manually, or explicitly extend that manifest/importer with reviewed tests. Do not call the original importer and claim it registered GDA tasks.

For manual registration after your review, an example command is below. This performs a write to GitHub only when you run it with an authenticated CLI. The command uses the complete Markdown body including metadata; it does not create labels, milestones, assignees, native dependency relationships, or approval evidence.

```bash
gh issue create --repo ther12k/rz-quran \
  --title "[GDA-001] Integrate the starter theme and optional UI cues" \
  --body-file asset-starter/github/issues/GDA-001.md
```

Run from the combined package root, and check for an existing matching GDA identifier first to avoid duplicates. Repeat intentionally for the other two bodies only if the tasks are adopted.

## Keep existing ownership intact

- GDM-005: synthetic fixtures and asset intake, not supplied UI demo completion.
- GDM-012: actual text/font rendering.
- GDM-013: instructional playback and interruption.
- GDM-023/GDM-024: real-device and performance evidence.
- GDM-027: actual rights/curriculum approvals.

A downloaded font or a generated mascot does not close any of those tickets on its own.
