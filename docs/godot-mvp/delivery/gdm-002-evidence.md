---
type: Evidence Record
title: GDM-002 — shared shell exports from one SHA, with GDA-001 asset adoption
description: Executed build evidence, pins, artifact hashes, smoke run, and explicit unexecuted checks.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-07'
sources:
- resource: gdm-002-build-runbook.md
  title: GDM-002 build runbook and pins
- resource: ../github/issues/GDM-002.md
  title: GDM-002 issue criteria
x_rzq:
  bundle_version: '1.1'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-002
---

# GDM-002 evidence (QA-02) + GDA-001 adoption record

## Candidate

| Field | Value |
|---|---|
| Client repository / commit | `ther12k/rzquran` @ `c16a2c7d02c2` (branch `main`, clean tree at build time) |
| Build ID (baked into all artifacts) | `c16a2c7d02c2-20260907T223253Z` |
| Godot editor + templates | `4.7.2.stable.official.ed1daf0bf`; templates `4.7.2.stable` (checksums in the [runbook](gdm-002-build-runbook.md)) |
| Renderer / language | Compatibility (gl_compatibility desktop+mobile), typed GDScript, no C# |
| Web variant | single-threaded (`variant/thread_support=false`), PWA disabled |
| Android toolchain | OpenJDK 21.0.12; SDK platform 36 / build-tools 36.0.0; Gradle 8.11.1 wrapper; arm64-v8a only |
| Content | fixture shell only (`content_mode` wiring arrives with GDM-005/006); no learning audio, no approved content |
| Executor / time | implementation agent (zcode), 2026-09-07 ~22:28 local (UTC+7) |

## Executed checks (QA-02)

| Criterion | Command / procedure | Result |
|---|---|---|
| Web export (real, headless) | `./scripts/build-kids.sh` → `--export-release "Web"` | **PASS** — 9 files in `build/kids-web/` (wasm 39.5 MB, pck, html, worklets, icons) |
| Linux native export + boot smoke | `--export-debug "Linux"`; run `build/kids-linux/rzq-kids --headless --quit-after 2` | **PASS** — stdout `[rzq-kids] build=c16a2c7d02c2-20260907T223253Z platform=native-https`; exit 0 |
| Android debug APK (real gradle build) | `--export-debug "Android"` (gradle 8.11.1, debug keystore outside repo) | **PASS** — `rzq-kids-debug.apk` (arm64-v8a, classes.dex, assets) |
| Shared scenes carry no web-only dependency | smoke binary runs native path; web adapter only loaded when `OS.has_feature("web")` | **PASS** — `platform=native-https` printed by exported binary |
| Visible build ID in development | `res://build/build_id.txt` packed via `include_filter`; printed + on-screen label | **PASS** — see smoke line above; file present in web pck and APK assets (verified by archive scan) |
| Same-SHA artifacts | all three exports in one `build-kids.sh` invocation from clean commit `c16a2c7d02c2` | **PASS** — web pck and Linux pck byte-identical (`beba9e0e…`), APK from same run |
| Import/parse pass | `godot --headless --import` (game project) | **PASS** — no script errors |
| Standalone asset preview import (GDA-001) | `godot --headless --import` in `asset-starter/godot-starter` | **PASS** — no errors; kept separate from the game project |
| No generated cache / signing secret committed | `.gitignore` covers `.godot/`, `game/build/`, `build/`, gradle outputs, `*.keystore` | **PASS** — commit `c16a2c7d02c2` contains sources + pinned template only |

## Artifact SHA-256 (subset; full list in build log)

| Artifact | SHA-256 |
|---|---|
| `build/kids-web/index.pck` | `beba9e0ee88b14405b2471981a4e0fc44d0a00ffdff8df7b1be563ea99fcabdb` |
| `build/kids-web/index.wasm` | `fc74679e3b97f76878947fcd4fbe1268cbfa6188182a2e33bbc3f5dc9bfa57d0` |
| `build/kids-web/index.html` | `40f5130d98eb5877808b84dbfe9999fb40f03012955a37ea3cd3e395ba8c0b86` |
| `build/kids-linux/rzq-kids` | `1a291d3d15e4180b60b0af96cf6458f11fe143636d76575ddf1e23d1a3f24f2e` |
| `build/kids-linux/rzq-kids.pck` | `beba9e0ee88b14405b2471981a4e0fc44d0a00ffdff8df7b1be563ea99fcabdb` (= web pck) |
| `build/kids-android/rzq-kids-debug.apk` | `f79e3b035572902fc01d384560ebfe6ca0f94cf0e20eafd00d64940065376f39` |

## GDA-001 asset adoption (this commit)

Adopted into `game/` with hashes matching `asset-starter/docs/asset-registry.md` exactly:

| File | SHA-256 |
|---|---|
| `game/theme/rzq_kids_theme.tres` | `178187e680150d93a2da7ec7e48a53856b8f9a4220aec214d5dda6d324b8d6f2` |
| `game/assets/audio/ui/ui_tap.wav` | `8c840c9234caf49be2c0f17cc681a0e6bf12f9a3b6513fc675777359d2d3b2fb` |
| `game/assets/audio/ui/ui_confirm.wav` | `1c4103acc8b72ee869a9371c3ae6016a082c7ece59a6299b4e4bd74d0e2600f7` |
| `game/assets/audio/ui/ui_complete.wav` | `b37aa7d835d4382f8f2ed7b5e63b4f15974f8083d8f9761673f74256d2d07d40` |

- Theme applied to the child-facing entry subtree (`scenes/entry/main.gd`); buttons/cards remain real Controls (StyleBoxFlat styling). **Minimum 48-unit targets are not yet enforced anywhere — no interactive lesson scene exists yet; GDM-011 owns that.**
- `services/audio_service.gd`: cues only on explicit actions; suppressed while `instructional_audio_active`; `stop_all()` on exit/switch/terminal states (callers arrive with lesson scenes).
- Not adopted: reference mockups, preview scene, font binaries (none supplied), Kenney packs (not downloaded — registry says the same).
- Exports contain no references/fonts/private content (archive-scan verified above).

## Bring-up issues found and fixed (recorded for reproducibility)

1. Headless exports do not populate the global script-class cache → all cross-script references use preload/path, not `class_name`.
2. Android gradle template layout is `game/android/build/` + `.build_version` marker (`4.7.2.stable`) at `game/android/`; `--install-android-build-template` hung headless, so the template was extracted manually and committed.
3. Godot's importer must not scan the gradle template (`.gdignore`) or AAPT rejects generated `.webp.import` files.
4. Raw `.txt` build-ID file needs `include_filter="build/build_id.txt"` to be packed.
5. Android export requires a project icon and `import_etc2_astc=true` even with no textures.

## Explicitly not executed (do not read as passed)

- No on-device run: **no physical Android/iPhone test** of the APK or web export (QA-32/QA-37 pending, needs named devices).
- No browser run of the web export (no HTTPS host wired yet; QA-31 pending).
- No audio playback verification on any target (QA-23 pending; WAV import verified only).
- No CI pipeline yet (GDM-022); no performance measurements (GDM-024).
- Android `one-click deploy`/adb not used; the `tcp:5037` daemon notice in logs is from the exporter's device probe and is non-fatal.

## Acceptance summary

GDM-002 acceptance criteria: versions/checksums/commands committed (**done**), real web export + Android debug APK from one SHA with a visible dev build ID (**done**, hashes above), shared scenes compile and run native without web dependencies (**done** via exported-binary smoke). Issue remains open for owner review; device-level QA intentionally unexecuted and listed above.
