# Architecture

- [ADR-001 — shared Godot activity, retained web platform](adr-001.md) — A scoped proposal for adding Godot without rebuilding the platform.
- [ADR-002 — dedicated MVP client repository](adr-002.md) — Owner decision of 2026-09-07: docs + Godot client live in a new repository; backend stays in `rz-quran`.
- [Godot project structure and state machine](godot-structure.md) — Scenes, services, adapters, and explicit state transitions.
- [System boundaries and integration map](overview.md) — Repository integration, trust boundaries, and request flow for the MVP.
- [Platform adapters and staging-only native pairing](platform-auth.md) — Explicit web/native authentication and lifecycle contracts with production exclusion.
- [Web preview and Android debug delivery](web-android-builds.md) — Reproducible export, local phone testing, CI artifacts, and deferred iOS steps.
