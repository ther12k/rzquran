---
type: Runbook
title: Web preview and Android debug delivery
description: Reproducible export, local phone testing, CI artifacts, and deferred iOS steps.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: web
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_web.html
  title: Godot — Exporting for the Web
- id: android
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_android.html
  title: Godot — Exporting for Android
- id: http
  resource: https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html
  title: Godot — Making HTTP requests
- id: ios
  resource: https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
  title: Godot — Exporting for iOS
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Build and test runbook

## Pin before building

GDM-002 records editor version, export-template version/checksums, renderer, scripting language, host runtime, Android JDK/SDK/build tools, and the exact working commands. Match editor/templates. Check current official instructions rather than copying a stale SDK list.[^android]

Choose Compatibility, typed GDScript and single-threaded web export. Disable PWA/service-worker caching in this scope. Keep HTML output and associated engine/data filenames aligned; the exporter generates dependent files.[^web]

## Intended commands

The following are command templates, **not executed results**. GDM-002 commits exact repo-specific equivalents after testing. Preset names below are proposed.

```sh
godot --headless --editor --path apps/kids-godot --quit
mkdir -p build/kids-web build/kids-android
godot --headless --path apps/kids-godot \
  --export-release "Web" ../../build/kids-web/index.html
godot --headless --path apps/kids-godot \
  --export-debug "Android" ../../build/kids-android/rzq-kids-debug.apk
```

Resolve export paths relative to the project explicitly in the actual build script; do not assume current-shell resolution. Never log keystore credentials. A debug signing key is development-only and must not become a production signing identity.

## Mobile browser loop

Export → serve under the existing authenticated preview host → open the preview on an actual phone. Use an approved HTTPS environment or locally trusted HTTPS server reachable on the test network. Do not disable certificate checks. No automatic public tunnel or external deployment is authorized by these instructions.

Serve `.wasm` correctly, use consistent asset versioning, and test a missing/truncated engine file. The React host supplies visible load progress, retry, unsupported-device explanation and an always-available HTML activity link. Do not download the engine on unrelated parent/admin routes. Record full cold payload including WASM/PCK/media, not just JavaScript gzip size.

## Android loop

Install the debug APK on an authorized test device; record model, OS, installation command, app/build IDs, and commit. Enable Internet permission only as required for this flow.[^http] Use staging pairing with a synthetic profile, complete the same session journey, then inspect pause/resume/back/logout and permission behavior. App restarts intentionally require new pairing in MVP.

## CI

Create separate checks for Godot import/parse, deterministic unit/scene tests, web export, Android export, existing backend/web regression, contract fixtures, secret/key leakage and package artifact checks. Pin third-party actions to reviewed immutable references. Cache tooling/imports with keys including version/lock changes; do not cache private media or grants. Keep signing credentials out of untrusted pull-request jobs.

Artifacts: web export archive, debug APK, commit/build/content-version manifest, SHA-256 checksums, executed test logs and device evidence links. Debug artifacts have restricted retention/access. Do not claim a device test from a headless export alone.

## Native iOS later

Keep platform interfaces compatible, but no native iOS deliverable is required here. Native iOS export needs macOS/Xcode.[^ios] Add a separate backlog when hardware, signing identities, test devices, authentication, accessibility and release requirements are available. iPhone Safari evidence covers the browser only.

## Rollback

Disable the new child route through the server/host flag, stop creation of new native grants, revoke existing staging grants, and restore the old HTML route. Preserve server progress. Record which build was disabled and why; never “roll back” by deleting progress or weakening review checks.

[^web]: Godot — Exporting for the Web.

[^android]: Godot — Exporting for Android.

[^http]: Godot — Making HTTP requests.

[^ios]: Godot — Exporting for iOS.
