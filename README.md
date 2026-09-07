# rzquran — RZ Qur'an Kids: Godot MVP client

Dedicated repository for the **RZ Qur'an Kids Godot MVP**: the shared Godot 2D learning client (mobile-browser web export + Android debug build) and its complete OKF documentation bundle.

Per [ADR-002](docs/godot-mvp/architecture/adr-002.md) (owner decision, 2026-09-07), the existing [rz-quran](https://github.com/ther12k/rz-quran) repository remains the **sole backend** (Bun/Elysia/PostgreSQL) and keeps the React parent/admin areas. The two repositories couple only through the documented API contract — no second backend.

## Layout

| Path | Contents |
|---|---|
| `docs/godot-mvp/` | OKF v0.2 documentation bundle: PRD, architecture (ADRs), API/content contracts, UX, 32 GitHub-ready issues (GDM-001–032), QA plans, agent handoff |
| `docs/godot-mvp/design/mockups/` | Owner-provided UI mockups (visual direction only) |
| *(root, upcoming)* | The Godot 4 client project and export tooling |

## Start here

1. Read [`docs/godot-mvp/README.md`](docs/godot-mvp/README.md), then the [MVP PRD](docs/godot-mvp/product/mvp-prd.md) and [ADR-001](docs/godot-mvp/architecture/adr-001.md) / [ADR-002](docs/godot-mvp/architecture/adr-002.md).
2. For agents: follow [`docs/godot-mvp/AGENTS.md`](docs/godot-mvp/AGENTS.md) and the copyable prompt in [`docs/godot-mvp/HANDOFF_PROMPT.md`](docs/godot-mvp/HANDOFF_PROMPT.md).
3. For the backlog: see [`docs/godot-mvp/github/README.md`](docs/godot-mvp/github/README.md) (dry-run-first issue importer).

GDM-001–026 deliver and verify the internal MVP; GDM-027–032 are a separately gated supervised pilot requiring real content/privacy approvals. Documentation is proposal-grade except where an owner decision is recorded (currently ADR-002).
