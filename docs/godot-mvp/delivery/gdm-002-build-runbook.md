---
type: Build Runbook
title: GDM-002 — Pinned toolchain and reproducible web/Android/Linux builds
description: Exact versions, checksums, layout, and commands for the shared client builds.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: zcode/implementation-agent
  at: '2026-09-07'
sources:
- resource: /architecture/web-android-builds.md
  title: Web preview and Android debug delivery
- resource: /architecture/adr-001.md
  title: ADR-001 — shared Godot activity, retained web platform
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
  issue_id: GDM-002
---

# GDM-002 — Build runbook and pins

## Pinned toolchain (working set, verified 2026-09-07)

| Component | Pin | Checksum / evidence |
|---|---|---|
| Godot editor | **4.7.2.stable** (`4.7.2.stable.official.ed1daf0bf`), Linux x86_64 | zip sha256 `cadd3204e728a35d3f13adb7fd0d7902636b79f6b95c40c265eb73b6c35329e4` (GitHub release API `digest`) |
| Export templates | `Godot_v4.7.2-stable_export_templates.tpz`, installed to `~/.local/share/godot/export_templates/4.7.2.stable/` (`version.txt` = `4.7.2.stable`) | tpz sha256 `f298490b8d44d934be425a5a65a51bf15f422428b229a06a6e11d9ffea248011` |
| Renderer / scripting | Compatibility (`gl_compatibility` desktop + mobile), typed GDScript, no C# | `game/project.godot` |
| Web variant | **Single-threaded** (`variant/thread_support=false`), no PWA/service worker | `game/export_presets.cfg` preset "Web" |
| JDK | OpenJDK **21.0.12** (`/usr/lib/jvm/java-21-openjdk-amd64`) | `java -version` |
| Android SDK | `~/Android/Sdk`: platform **android-36**, build-tools 34/36 | `sdkmanager --list_installed` equivalent listing |
| Gradle build template | Engine template at `game/android/build/`; version marker `game/android/.build_version` = `4.7.2.stable` (checked against `GODOT_VERSION_FULL_CONFIG`; a wrong value fails the export with an explicit mismatch message); Gradle **8.11.1** wrapper; compileSdk 36 / minSdk 24 | committed in repo |
| Debug signing | RSA-2048 debug keystore at `~/.local/share/rzq-godot/debug.keystore` (alias `androiddebugkey`) — **outside the repository, never committed** | `keytool -genkeypair` in session log |

Editor settings used for headless export (`~/.config/godot/editor_settings-4.7.tres`): `export/android/java_sdk_path`, `export/android/android_sdk_path`, `export/android/debug_keystore{,_user,_pass}`.

## Project layout (this repository)

```text
game/                      the shared Godot project (ADR-002 placement)
  project.godot            Compatibility renderer, portrait, ETC2/ASTC import
  icon.svg                 placeholder dev icon
  export_presets.cfg       Web / Android / Linux presets (no credentials)
  scenes/entry/            composition root (the ONLY adapter chooser)
  scripts/build_info.gd    autoload; reads res://build/build_id.txt
  platform/                typed PlatformClient boundary + web/native adapters
  android/build/           engine gradle build template (pinned, committed)
scripts/build-kids.sh      one-command build: build ID → import → 3 exports → smoke → hashes
build/                     outputs (gitignored)
```

Design rules honored (QA-02 oracles): shared scenes depend only on `platform/platform_client.gd`; the web adapter (`JavaScriptBridge`) is loaded exclusively by the composition root when `OS.has_feature("web")`, so native builds pack but never execute web code — the exported Linux binary runs `platform=native-https`. Export presets exclude `android/*` from packed resources. A visible build ID (`<git-sha12>-<UTC timestamp>`) is written to `res://build/build_id.txt` before packing, shown on the entry screen and printed to stdout.

## Commands

```sh
# one-shot (web + Linux smoke + Android debug APK + sha256 list)
export JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
export ANDROID_HOME=$HOME/Android/Sdk
./scripts/build-kids.sh

# individual steps
godot --headless --path game --import
godot --headless --path game --export-release "Web"     ../build/kids-web/index.html
godot --headless --path game --export-debug  "Linux"    ../build/kids-linux/rzq-kids
godot --headless --path game --export-debug  "Android"  ../build/kids-android/rzq-kids-debug.apk
```

Notes recorded during bring-up (deviations from the generic docs):

- The Android gradle template must sit at `game/android/build/` (installer layout), with the version marker at `game/android/.build_version` containing `4.7.2.stable`. Manual install = extract the template's `android_source.zip` there + write the marker; `--install-android-build-template` hung headless in this environment, so the manual layout is used and committed.
- `export/android` requires a project icon and ETC2/ASTC import enabled even with no textures (`textures/vram_compression/import_etc2_astc=true`).
- Export paths are relative to `game/` (→ `../build/...`), not the repository root.
- `adb` daemon noise ("cannot connect to daemon at tcp:5037") during headless exports is non-fatal: no deployment step is involved.

## CI expectations (GDM-022 will wire these)

Deterministic checks on candidate SHA: Godot import, the three exports above, smoke-run grep of `build=<id> platform=native-https`, sha256 manifest of `build/kids-web/*`, `kids-linux/*`, `kids-android/*.apk`. Signing material stays out of CI cache/secrets scope for debug builds; production signing is out of MVP scope entirely.

## Rollback

The client is served/deployed nowhere yet; rollback = do not publish the artifact and revoke any staging grants (per ADR-001/002). The web pck/wasm are versioned by build ID path when hosted later, so an earlier build can be re-served without rebuilding.
