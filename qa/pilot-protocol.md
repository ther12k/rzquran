---
type: Pilot Plan
title: Supervised pilot protocol scaffold
description: A gated protocol outline that requires actual human decisions and observations.
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

# Not permission to recruit

This is a scaffold for GDM-028, not an approved protocol. GDM-027 and GDM-028 must supply actual content/privacy authorization before GDM-029. Use synthetic participants in engineering rehearsal; do not count them as usability evidence.

## Decisions required before recruitment

Pilot owner chooses target age/eligibility, accessibility needs, sample size, recruitment/consent procedure, supervision, session duration, withdrawal/stopping rules, allowed devices, data retention, observation storage and thresholds for success. These fields are intentionally not preapproved. Default recording policy is no child photo, voice, video or screen recording with identifying data.

## Proposed task script for owner review

Adult selects profile or approves Android pairing. Child finds the one lesson, listens to an example, answers a prompt, responds to gentle wrong feedback, finishes, then exits. Adult locates the practice result. Include optional accessible HTML presentation when relevant and authorized. Do not deliberately mislead a child with incorrect religious content to simulate an error.

Observer notes task completion, number/type of prompts required, accidental taps, audibility, glyph legibility, perceived meaning of result, ability to stop and technical interruptions. Separate observable facts from interpretation. Do not score religious ability from the pilot.

## Observation record

| Field | Planned content |
|---|---|
| Session code | Pseudonymous code, not child's name |
| Authorization reference | Reference only in permitted storage |
| Candidate/content/device | Exact versions |
| Task and observable event | Factual description |
| Assistance | Type and count defined by protocol |
| Severity and finding ID | Assigned after triage |
| Stopped/withdrawn | Record permitted minimum; follow deletion decisions |

## Remediation and acceptance

GDM-030 turns actual findings into defects or explicit dispositions and reruns regression. No observations does not automatically mean no defects; distinguish “not observed,” “not tested,” and “no issue found in tested scenario.” GDM-031 reruns operational acceptance on the revised candidate. GDM-032 records owner decisions. None authorizes public launch or app stores.
