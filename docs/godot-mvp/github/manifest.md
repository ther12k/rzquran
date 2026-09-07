---
type: Import Manifest
title: Canonical GitHub registration manifest
description: Machine-readable issue records inside Markdown with immutable issue-body hashes.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: gh-api
  resource: https://cli.github.com/manual/gh_api
  title: GitHub CLI — gh api
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Canonical import manifest

The JSON fence below is consumed by the [importer](import-issues.md). It does not register anything by itself. IDs are stable GDM identifiers, not actual GitHub issue numbers. SHA-256 values cover the complete canonical issue documents including OKF frontmatter. Rebuild/review this manifest after intentional issue-source edits; never bypass mismatch errors.

<!-- BEGIN_MANIFEST -->
```json
{
  "schema_version": 1,
  "bundle_version": "1.0",
  "namespace": "rzq-godot-mvp",
  "milestones": [
    {
      "key": "M0",
      "title": "GDM M0 - Foundation and scope",
      "description": "Inspect baseline, pin a shared project, define safe contracts and fixtures."
    },
    {
      "key": "M1",
      "title": "GDM M1 - Authoritative integration",
      "description": "Reuse session/progress services; add bounded web/native adapters."
    },
    {
      "key": "M2",
      "title": "GDM M2 - One learning journey",
      "description": "Home, examples, three questions, result, accessible equivalent and parent summary."
    },
    {
      "key": "M3",
      "title": "GDM M3 - Internal MVP verification",
      "description": "Web and Android artifacts, real-device checks, security and internal acceptance."
    },
    {
      "key": "M4",
      "title": "GDM M4 - Supervised pilot gates",
      "description": "Actual content/privacy evidence, observed pilot, remediation, operational preflight and owner acceptance; no public launch."
    }
  ],
  "labels": [
    {
      "name": "area:godot-mvp",
      "color": "226544",
      "description": "Shared Godot child-learning MVP"
    },
    {
      "name": "kind:engineering",
      "color": "1D76DB",
      "description": "Implementation or engineering hardening"
    },
    {
      "name": "kind:verification",
      "color": "5319E7",
      "description": "Actual execution and evidence, not tooling alone"
    },
    {
      "name": "kind:human-gate",
      "color": "B60205",
      "description": "Actual external owner or reviewer evidence required"
    },
    {
      "name": "kind:pilot",
      "color": "D93F0B",
      "description": "Supervised real-participant observation"
    },
    {
      "name": "track:internal-mvp",
      "color": "0E8A16",
      "description": "Required for internal synthetic-profile MVP"
    },
    {
      "name": "track:supervised-pilot",
      "color": "FBCA04",
      "description": "Separate conditionally authorized supervised pilot"
    },
    {
      "name": "platform:shared",
      "color": "C5DEF5",
      "description": "Shared client, services or multi-platform acceptance"
    },
    {
      "name": "platform:web",
      "color": "BFDADC",
      "description": "Browser host, HTML equivalent or parent web interface"
    },
    {
      "name": "platform:android",
      "color": "C2E0C6",
      "description": "Native Android internal debug client"
    },
    {
      "name": "priority:p0",
      "color": "B60205",
      "description": "Required for scoped internal MVP"
    },
    {
      "name": "priority:p1",
      "color": "D93F0B",
      "description": "Required only for authorized supervised pilot track"
    }
  ],
  "issues": [
    {
      "id": "GDM-001",
      "title": "[GDM-001] Inspect the existing repository and map the reuse baseline",
      "file": "github/issues/GDM-001.md",
      "sha256": "ff7bf544701e6e13651c03562c4f511e80540aee1d74e44bce9c089d8490b46a",
      "milestone": "GDM M0 - Foundation and scope",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [],
      "requirements": [
        "R01",
        "R02",
        "R12",
        "R15"
      ],
      "qa_checks": [
        "QA-01"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-002",
      "title": "[GDM-002] Pin Godot and produce shared web and Android shell exports",
      "file": "github/issues/GDM-002.md",
      "sha256": "09b6e8ce55b9666e54c29e495d86c60a5b56d7a1134e0911b61cf8e2e7f29d47",
      "milestone": "GDM M0 - Foundation and scope",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-001"
      ],
      "requirements": [
        "R02",
        "R13"
      ],
      "qa_checks": [
        "QA-02"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-003",
      "title": "[GDM-003] Define executable API and content projection contracts",
      "file": "github/issues/GDM-003.md",
      "sha256": "4290ad6e775e0a9c535e6be9580f0506560009ad359538319fd9429d14180600",
      "milestone": "GDM M0 - Foundation and scope",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-001",
        "GDM-004"
      ],
      "requirements": [
        "R04",
        "R06",
        "R07",
        "R12"
      ],
      "qa_checks": [
        "QA-03",
        "QA-04"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-004",
      "title": "[GDM-004] Approve engineering threat boundaries and native staging design",
      "file": "github/issues/GDM-004.md",
      "sha256": "8423155ac86dd60fcc084015e3eb98dece1f536992aa6070007266285f55ab25",
      "milestone": "GDM M0 - Foundation and scope",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-001"
      ],
      "requirements": [
        "R01",
        "R08",
        "R11",
        "R12",
        "R15"
      ],
      "qa_checks": [
        "QA-05"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-005",
      "title": "[GDM-005] Prepare bounded fixtures and reviewed-asset intake records",
      "file": "github/issues/GDM-005.md",
      "sha256": "740fba457bafd000796663de74004fa72e100386fbbdc5cba9876060fc471f95",
      "milestone": "GDM M0 - Foundation and scope",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-003",
        "GDM-004"
      ],
      "requirements": [
        "R04",
        "R05",
        "R12"
      ],
      "qa_checks": [
        "QA-06"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-006",
      "title": "[GDM-006] Expose authorized bootstrap, session and media reads",
      "file": "github/issues/GDM-006.md",
      "sha256": "0282f6b86bf9ec7b445cd4a7b903ce5d9b0bc07da7e42520094b7fbc36fc8acd",
      "milestone": "GDM M1 - Authoritative integration",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-003",
        "GDM-005",
        "GDM-010"
      ],
      "requirements": [
        "R01",
        "R04",
        "R05",
        "R08",
        "R12"
      ],
      "qa_checks": [
        "QA-07",
        "QA-08",
        "QA-09"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-007",
      "title": "[GDM-007] Implement transactional answer, finish and replay semantics",
      "file": "github/issues/GDM-007.md",
      "sha256": "befd96c879bf75afa78f7553ebb23a0d63f7cb260544382efa7ba46ebfc96ab4",
      "milestone": "GDM M1 - Authoritative integration",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-006",
        "GDM-010"
      ],
      "requirements": [
        "R06",
        "R07",
        "R08",
        "R10",
        "R12"
      ],
      "qa_checks": [
        "QA-10",
        "QA-11",
        "QA-12",
        "QA-13"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-008",
      "title": "[GDM-008] Integrate the browser host bridge with existing auth",
      "file": "github/issues/GDM-008.md",
      "sha256": "fd9edd5cd9316511b8a683acd47a25da623c02b45f2373753291e289b08e3d78",
      "milestone": "GDM M1 - Authoritative integration",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:web",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-002",
        "GDM-004",
        "GDM-006"
      ],
      "requirements": [
        "R01",
        "R02",
        "R08",
        "R12"
      ],
      "qa_checks": [
        "QA-14",
        "QA-15"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-009",
      "title": "[GDM-009] Build staging-only Android pairing and native transport",
      "file": "github/issues/GDM-009.md",
      "sha256": "e5989b085eba4db9f5852ba299b3b1655ca26c7d4dffce7c7a3d5c5fbc0b0903",
      "milestone": "GDM M1 - Authoritative integration",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:android",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-002",
        "GDM-004",
        "GDM-006",
        "GDM-010"
      ],
      "requirements": [
        "R02",
        "R11",
        "R12"
      ],
      "qa_checks": [
        "QA-16",
        "QA-17",
        "QA-18"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-010",
      "title": "[GDM-010] Map minimal persistence, cleanup and deletion hooks",
      "file": "github/issues/GDM-010.md",
      "sha256": "446f2130298af3a17293b42979b7cad683c2d7f361ef0cd2e379ca508ebfaeda",
      "milestone": "GDM M1 - Authoritative integration",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-003",
        "GDM-004"
      ],
      "requirements": [
        "R07",
        "R10",
        "R11",
        "R12"
      ],
      "qa_checks": [
        "QA-19",
        "QA-20"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-011",
      "title": "[GDM-011] Build responsive Godot entry and one-lesson home",
      "file": "github/issues/GDM-011.md",
      "sha256": "eaa75fe4f0eaa4cfd561418b9eeafbeaa29bc0d49828118aab99d1754ff332e4",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-002",
        "GDM-003"
      ],
      "requirements": [
        "R02",
        "R03",
        "R08"
      ],
      "qa_checks": [
        "QA-21"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-012",
      "title": "[GDM-012] Render learning examples and Arabic-ready option controls",
      "file": "github/issues/GDM-012.md",
      "sha256": "041c2671dcb5a20bcffc166d36bf76f9489d0c65c2a3fead8eecfe48f608c06e",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-005",
        "GDM-011"
      ],
      "requirements": [
        "R03",
        "R04",
        "R06"
      ],
      "qa_checks": [
        "QA-22"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-013",
      "title": "[GDM-013] Implement explicit audio playback and interruption handling",
      "file": "github/issues/GDM-013.md",
      "sha256": "4450400e4c44ce0a9578188dcfb6e4d41c454da282f2e0a4130bca6d842a07b6",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-006",
        "GDM-012"
      ],
      "requirements": [
        "R05",
        "R08",
        "R12"
      ],
      "qa_checks": [
        "QA-23",
        "QA-24"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-014",
      "title": "[GDM-014] Connect the three-round lesson state machine",
      "file": "github/issues/GDM-014.md",
      "sha256": "7a0354724f658985495eeca3dfa21ca4ca7751ca186c31b93b1a08328935f982",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-007",
        "GDM-012",
        "GDM-013"
      ],
      "requirements": [
        "R05",
        "R06",
        "R08"
      ],
      "qa_checks": [
        "QA-25"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-015",
      "title": "[GDM-015] Build server-confirmed results and repeat flow",
      "file": "github/issues/GDM-015.md",
      "sha256": "1641072901b114929bb4061cf4e4fb2e159cca2d355e106ed16b4684682cfa5b",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-014"
      ],
      "requirements": [
        "R07",
        "R10"
      ],
      "qa_checks": [
        "QA-26"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-016",
      "title": "[GDM-016] Handle pause, lost responses, expiry and profile switches",
      "file": "github/issues/GDM-016.md",
      "sha256": "31ed969dc2a302488e53609bb9b64e345e867e0c2d1192a06bc4053517677b3f",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-008",
        "GDM-009",
        "GDM-014"
      ],
      "requirements": [
        "R08",
        "R11",
        "R12"
      ],
      "qa_checks": [
        "QA-27",
        "QA-28"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-017",
      "title": "[GDM-017] Preserve an equivalent accessible HTML activity",
      "file": "github/issues/GDM-017.md",
      "sha256": "d4887eba89989b8d7b704aa06dda53bfa34492040d331def716cd30e44f2e225",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:web",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-007",
        "GDM-013",
        "GDM-015"
      ],
      "requirements": [
        "R05",
        "R06",
        "R07",
        "R09"
      ],
      "qa_checks": [
        "QA-29"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-018",
      "title": "[GDM-018] Integrate the existing parent practice summary",
      "file": "github/issues/GDM-018.md",
      "sha256": "a7bcb80088384900982315c8f10c4505e92c186ac66b3384ca99bbfd970991c4",
      "milestone": "GDM M2 - One learning journey",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:web",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-007",
        "GDM-010",
        "GDM-015"
      ],
      "requirements": [
        "R01",
        "R07",
        "R10"
      ],
      "qa_checks": [
        "QA-30"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-019",
      "title": "[GDM-019] Integrate real web export loading and fallback",
      "file": "github/issues/GDM-019.md",
      "sha256": "822296cf55671755c850112076848e9a8cee91a5d8f259a91832f6c2070c0a49",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:web",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-008",
        "GDM-011",
        "GDM-015",
        "GDM-016",
        "GDM-017"
      ],
      "requirements": [
        "R02",
        "R03",
        "R08",
        "R09",
        "R13"
      ],
      "qa_checks": [
        "QA-31"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-020",
      "title": "[GDM-020] Produce and smoke-test the integrated Android debug app",
      "file": "github/issues/GDM-020.md",
      "sha256": "48ac3cffb6b5f45f45da7eb44f50f0a6728fd7c92dec6039bfb61a2ec1568055",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:android",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-009",
        "GDM-015",
        "GDM-016"
      ],
      "requirements": [
        "R02",
        "R08",
        "R11",
        "R13"
      ],
      "qa_checks": [
        "QA-32"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-021",
      "title": "[GDM-021] Execute authorization, leakage, recall and deletion regression",
      "file": "github/issues/GDM-021.md",
      "sha256": "537d4ad4b3a884b36dc7b09687b6339c901ec2022e037d861e375b2007aaa472",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-007",
        "GDM-008",
        "GDM-009",
        "GDM-010",
        "GDM-016",
        "GDM-019",
        "GDM-020"
      ],
      "requirements": [
        "R01",
        "R08",
        "R11",
        "R12"
      ],
      "qa_checks": [
        "QA-33",
        "QA-34",
        "QA-35"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-022",
      "title": "[GDM-022] Automate unit, scene, contract and export checks in CI",
      "file": "github/issues/GDM-022.md",
      "sha256": "f76e0229b906cfd7a1bd54f348466b5de2356ac811c49d56edd7d1071f5c13b3",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-017",
        "GDM-018",
        "GDM-019",
        "GDM-020"
      ],
      "requirements": [
        "R02",
        "R08",
        "R13"
      ],
      "qa_checks": [
        "QA-36"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-023",
      "title": "[GDM-023] Run real-device responsive, Arabic/audio and accessibility checks",
      "file": "github/issues/GDM-023.md",
      "sha256": "55cadb2a18f04e0fa72dbc8720d87244300f71d4c06992773962312f19e1d308",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:verification",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-017",
        "GDM-018",
        "GDM-019",
        "GDM-020"
      ],
      "requirements": [
        "R03",
        "R04",
        "R05",
        "R09",
        "R14"
      ],
      "qa_checks": [
        "QA-37"
      ],
      "kind": "verification",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-024",
      "title": "[GDM-024] Measure cold startup, frame time and API load",
      "file": "github/issues/GDM-024.md",
      "sha256": "c77bea632e866cd481f720abe98662444ff48e63ac709e485c0629f99d143a20",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:verification",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-019",
        "GDM-020",
        "GDM-022"
      ],
      "requirements": [
        "R13",
        "R14"
      ],
      "qa_checks": [
        "QA-38"
      ],
      "kind": "verification",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-025",
      "title": "[GDM-025] Implement internal readiness checks and safe feature rollback",
      "file": "github/issues/GDM-025.md",
      "sha256": "7a7c0b7fb1ec1078466fe189de4b147b2aa7138ee3618189110aeedc5c53c136",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-021",
        "GDM-022"
      ],
      "requirements": [
        "R12",
        "R13",
        "R15"
      ],
      "qa_checks": [
        "QA-39"
      ],
      "kind": "engineering",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-026",
      "title": "[GDM-026] Execute and record internal MVP acceptance",
      "file": "github/issues/GDM-026.md",
      "sha256": "1c116164fe5339455a1156570de7d80524d0c820d939888ed63803009897a045",
      "milestone": "GDM M3 - Internal MVP verification",
      "labels": [
        "area:godot-mvp",
        "kind:verification",
        "track:internal-mvp",
        "platform:shared",
        "priority:p0"
      ],
      "depends_on": [
        "GDM-005",
        "GDM-018",
        "GDM-021",
        "GDM-022",
        "GDM-023",
        "GDM-024",
        "GDM-025"
      ],
      "requirements": [
        "R01",
        "R02",
        "R03",
        "R04",
        "R05",
        "R06",
        "R07",
        "R08",
        "R09",
        "R10",
        "R11",
        "R12",
        "R13",
        "R14",
        "R15"
      ],
      "qa_checks": [
        "QA-40"
      ],
      "kind": "verification",
      "track": "internal-mvp"
    },
    {
      "id": "GDM-027",
      "title": "[GDM-027] Obtain actual learning-pack rights and curriculum approval",
      "file": "github/issues/GDM-027.md",
      "sha256": "72eca2dadb858161d02f26e2c28ea276f5bba4c23f8154c93dfaba61adcb3849",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:human-gate",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-005",
        "GDM-012",
        "GDM-013"
      ],
      "requirements": [
        "R04",
        "R05",
        "R12",
        "R15"
      ],
      "qa_checks": [
        "QA-41"
      ],
      "kind": "human-gate",
      "track": "supervised-pilot"
    },
    {
      "id": "GDM-028",
      "title": "[GDM-028] Obtain participant, privacy and pilot-protocol authorization",
      "file": "github/issues/GDM-028.md",
      "sha256": "43c31db86ac2163fc3b7b0147a54f8cceff5b4e6168e8a9356f928669ee3fe15",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:human-gate",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-004",
        "GDM-025"
      ],
      "requirements": [
        "R12",
        "R15"
      ],
      "qa_checks": [
        "QA-42"
      ],
      "kind": "human-gate",
      "track": "supervised-pilot"
    },
    {
      "id": "GDM-029",
      "title": "[GDM-029] Run the authorized supervised usability pilot",
      "file": "github/issues/GDM-029.md",
      "sha256": "c891d6987464d31e053c8c10772861ce44ad1d4f4ac32a6b3ec5eca19c3f4192",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:pilot",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-026",
        "GDM-027",
        "GDM-028"
      ],
      "requirements": [
        "R03",
        "R04",
        "R05",
        "R09",
        "R14",
        "R15"
      ],
      "qa_checks": [
        "QA-43"
      ],
      "kind": "pilot",
      "track": "supervised-pilot"
    },
    {
      "id": "GDM-030",
      "title": "[GDM-030] Resolve pilot findings and rerun affected regression",
      "file": "github/issues/GDM-030.md",
      "sha256": "fb177a19930a290a9b64688dedb6d84cb18f0fdc28351540e40071a7f8e3b484",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:engineering",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-029"
      ],
      "requirements": [
        "R03",
        "R04",
        "R05",
        "R08",
        "R09",
        "R12",
        "R14",
        "R15"
      ],
      "qa_checks": [
        "QA-44"
      ],
      "kind": "engineering",
      "track": "supervised-pilot"
    },
    {
      "id": "GDM-031",
      "title": "[GDM-031] Execute pilot-candidate operational preflight and rollback drill",
      "file": "github/issues/GDM-031.md",
      "sha256": "40e2dd20610bed009df70ba445a0ab3ad8104c44e9af054b1cd83bc0e96e424a",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:verification",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-026",
        "GDM-027",
        "GDM-028",
        "GDM-030"
      ],
      "requirements": [
        "R08",
        "R12",
        "R13",
        "R15"
      ],
      "qa_checks": [
        "QA-45"
      ],
      "kind": "verification",
      "track": "supervised-pilot"
    },
    {
      "id": "GDM-032",
      "title": "[GDM-032] Record the human supervised-pilot acceptance decision",
      "file": "github/issues/GDM-032.md",
      "sha256": "f0f8e647efc026ff9b9dda388342ce2c59bba88b6a462ccb749bbd37086b01ac",
      "milestone": "GDM M4 - Supervised pilot gates",
      "labels": [
        "area:godot-mvp",
        "kind:human-gate",
        "track:supervised-pilot",
        "platform:shared",
        "priority:p1"
      ],
      "depends_on": [
        "GDM-031"
      ],
      "requirements": [
        "R15"
      ],
      "qa_checks": [
        "QA-46"
      ],
      "kind": "human-gate",
      "track": "supervised-pilot"
    }
  ]
}
```
<!-- END_MANIFEST -->

Registration is create-only. An existing marked issue is preserved even when its original task body differs from this local document; reconcile accepted contract changes manually. The importer checks all local Markdown against a committed immutable repository tree before any writes so generated source links point to the actual documents.
