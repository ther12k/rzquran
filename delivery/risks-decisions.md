---
type: Decision Register
title: Risks, assumptions and pending decisions
description: Explicit boundaries for scope, testing hardware, content, auth and release.
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

# Decision register

| ID | Decision/risk | Proposed default | Required resolution |
|---|---|---|---|
| D01 | Existing repository may differ from report | Reuse only after inspection | GDM-001 maps actual code/contracts |
| D02 | Godot/platform version compatibility | Stable pin + matching templates; no guessed latest number | GDM-002 records working pins |
| D03 | Browser engine payload may exceed budget | Lazy-load only the activity; retain HTML | GDM-024 measures; owner decides on failed budget |
| D04 | Native auth scope | Staging-only, short-lived, in-memory pairing grant | GDM-004/009 technical approval; production login deferred |
| D05 | Approved three-item letter/audio pack absent | Explicit shapes fixture, never fake learning | GDM-027 actual source/rights/curriculum evidence |
| D06 | Mobile/canvas accessibility limits | Maintain equivalent HTML | GDM-017/023 actual assistive evidence |
| D07 | iPhone/Android test hardware unavailable | Mark checks blocked; no guessed pass | GDM-023 resource owner provides devices |
| D08 | Pilot scope/legal decisions absent | No real participants/data | GDM-028 authorized decisions |
| D09 | Additional data retention | Reuse existing policy; cleanup new grants/replay | GDM-004/010; privacy owner resolves exceptions |
| D10 | Existing parent UI metrics differ | Add minimal mapped practice card | GDM-018 documents semantic mapping |
| D11 | Web/native build and content drift | Same SHA + explicit release hash | GDM-022/026 evidence packet |
| D12 | Desired future stores/iOS/offline features | Excluded from this backlog | New scoped decision before implementation |
| D13 | Repository placement of the MVP client | Resolved: dedicated repository per [ADR-002](../architecture/adr-002.md), amending ADR-001 | Owner decision 2026-09-07; backend additions remain in `rz-quran` |

Estimates and performance targets are planning inputs, not established measurements. A content/publication approval is not implied by `status: draft` metadata, a generated timestamp, passing schema checks or a previous unrelated human review.

Native grant flow is a deliberately narrow internal exception. Do not gradually broaden it to real production users without a new authentication/security design. If the repository already has a reviewed native flow, prefer mapping it rather than duplicating this proposal, with an explicit decision.
