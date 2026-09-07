---
type: Technical Architecture
title: System boundaries and integration map
description: Repository integration, trust boundaries, and request flow for the MVP.
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

# Architecture

```text
Existing React web application
  parent auth/profile selection/approval/summary
  child entry + accessible HTML activity
  same-origin Godot host + allowlisted message bridge
                      |
Shared Godot scenes --+-- Web adapter -> host -> existing HTTPS API
                      |
                      +-- Native adapter -> existing HTTPS API
                                                |
                       Existing Bun/Elysia services
                     auth, ownership, content, progress
                                                |
                         PostgreSQL + private media
```

## Existing repository first

GDM-001 records actual directories, routes, middleware, current migrations, existing feature flags, and recent issue evidence. Suggested `apps/kids-godot/` is a placement proposal, not a claim about the repository. Use the existing conventions where compatible. No new database, separate backend, Redis, vector store, event bus, or multiplayer server.

## Boundaries

**Server:** validates profile access, parent gate, session/grant status, content release, current question, choice membership, replay/conflict behavior, completion, and summary aggregation. Private answer keys remain here.

**Godot:** renders permitted data, handles child input and animation, maintains transient pending-request IDs, plays authorized media, and shows only server-confirmed outcomes.

**Web host:** reuses authenticated browser requests and CSRF defenses, exposes fixed actions, owns iframe/runtime lifecycle, restores focus on exit, and offers the HTML route. The bridge is not a substitute for server access control.

**Native adapter:** uses scoped in-memory credentials, approved HTTPS origins, structured errors, bounded retries, and lifecycle cleanup. It cannot call parent/admin actions.

## Runtime data flow

1. Bootstrap returns authorized profile display fields, content mode, available lesson summary and build compatibility.
2. Start creates a release-pinned server session with three example items and one current question.
3. Media requests fetch only session-authorized asset bytes through the API gateway.
4. Answer submission validates and commits a round; feedback and the next authorized question follow.
5. Finish atomically records one completion per session and returns server-derived summary fields.
6. Parent summary uses the existing protected read path. Browser and Android results are the same data, not reconciled client counters.

## Configuration

Server controls enabled clients/environments, content mode/release, minimum contract version, native pairing availability, limits, and kill switch. Public client configuration contains only API origin, build/contract identifiers, and non-secret UI defaults. Never let query parameters promote fixtures to reviewed content.

## Deployment boundary

Web assets can be staged as static versioned output behind the existing host. HTTPS API/media traffic uses current services. The native APK contains engine, scenes, and permitted generic UI assets, not production account records or a private content corpus. Keep the previous web route available for rollback. See [build runbook](web-android-builds.md).
