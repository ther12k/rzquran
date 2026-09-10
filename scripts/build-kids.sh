#!/usr/bin/env bash
# Build the shared kids client (GDM-002): web export + Android debug APK +
# Linux smoke binary from one commit, with a visible build ID in all three.
#
# Pins are documented in docs/godot-mvp/delivery/gdm-002-build-runbook.md.
# Override with env: GODOT_BIN=/path/to/godot
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
GODOT_BIN="${GODOT_BIN:-$HOME/.local/share/rzq-godot/editor/Godot_v4.7.2-stable_linux.x86_64}"

if [[ ! -x "$GODOT_BIN" ]]; then
  echo "Godot binary not found or not executable: $GODOT_BIN (set GODOT_BIN)" >&2
  exit 1
fi

BUILD_ID="$(git -C "$REPO_ROOT" rev-parse --short=12 HEAD)-$(date -u +%Y%m%dT%H%M%SZ)"
WEB_DIR="$REPO_ROOT/build/kids-web"
APK_DIR="$REPO_ROOT/build/kids-android"
LINUX_DIR="$REPO_ROOT/build/kids-linux"
TEMPLATE_ZIP="${GODOT_TEMPLATE_ZIP:-$HOME/.local/share/godot/export_templates/4.7.2.stable/android_source.zip}"

# The engine gradle AARs exceed GitHub's file limits, so they are not
# committed; restore them from the checksum-verified pinned export template.
ensure_template_libs() {
  local aar_debug="$REPO_ROOT/game/android/build/libs/debug/godot-lib.template_debug.aar"
  local aar_release="$REPO_ROOT/game/android/build/libs/release/godot-lib.template_release.aar"
  local want_debug="9cfb115e508ce98e8cf9b655927ef894cdfc2fede18a82f995842388f7754102"
  local want_release="8791eecfe7c96a4de2d188a0bccfe9b83b92589a5a6825847473416a990e8629"
  local need=0
  [[ -f "$aar_debug" && "$(sha256sum "$aar_debug" | cut -d' ' -f1)" == "$want_debug" ]] || need=1
  [[ -f "$aar_release" && "$(sha256sum "$aar_release" | cut -d' ' -f1)" == "$want_release" ]] || need=1
  if [[ $need -eq 1 ]]; then
    if [[ ! -f "$TEMPLATE_ZIP" ]]; then
      echo "Engine AARs missing and template zip not found: $TEMPLATE_ZIP" >&2
      echo "Install Godot 4.7.2.stable export templates first (see docs/godot-mvp/delivery/gdm-002-build-runbook.md)." >&2
      exit 1
    fi
    echo "Restoring engine AARs from pinned template zip..."
    unzip -q -o -j "$TEMPLATE_ZIP" "libs/debug/godot-lib.template_debug.aar" -d "$(dirname "$aar_debug")"
    unzip -q -o -j "$TEMPLATE_ZIP" "libs/release/godot-lib.template_release.aar" -d "$(dirname "$aar_release")"
    (cd "$REPO_ROOT" && echo "$want_debug  game/android/build/libs/debug/godot-lib.template_debug.aar" | sha256sum -c -) || exit 1
    (cd "$REPO_ROOT" && echo "$want_release  game/android/build/libs/release/godot-lib.template_release.aar" | sha256sum -c -) || exit 1
  fi
}
ensure_template_libs

mkdir -p "$REPO_ROOT/game/build" "$WEB_DIR" "$APK_DIR" "$LINUX_DIR"
printf '%s' "$BUILD_ID" > "$REPO_ROOT/game/build/build_id.txt"
echo "Building commit $(git -C "$REPO_ROOT" rev-parse HEAD) as $BUILD_ID"

# Import pass: parse/import all resources before exporting.
"$GODOT_BIN" --headless --path "$REPO_ROOT/game" --import

rm -f "$WEB_DIR"/* "$APK_DIR"/* "$LINUX_DIR"/*
"$GODOT_BIN" --headless --path "$REPO_ROOT/game" \
  --export-release "Web" "$WEB_DIR/index.html"
"$GODOT_BIN" --headless --path "$REPO_ROOT/game" \
  --export-debug "Linux" "$LINUX_DIR/rzq-kids"
"$GODOT_BIN" --headless --path "$REPO_ROOT/game" \
  --export-debug "Android" "$APK_DIR/rzq-kids-debug.apk"

# Native smoke run (QA-02 oracle): the exported Linux binary boots its shared
# scenes and prints the visible build ID; the web adapter is never loaded.
# The app now runs a live pairing flow, so wait for the boot line to appear
# (bounded) instead of racing the pipe at process exit.
rm -f /tmp/rzq-smoke.log
RZQ_API_BASE="http://127.0.0.1:3310" "$LINUX_DIR/rzq-kids" --headless --quit-after 60 > /tmp/rzq-smoke.log 2>&1 &
SMOKE_PID=$!
for _ in $(seq 1 40); do
  grep -aq "build=$BUILD_ID platform=native-https" /tmp/rzq-smoke.log && break
  kill -0 "$SMOKE_PID" 2>/dev/null || break
  sleep 1
done
if ! grep -aq "build=$BUILD_ID platform=native-https" /tmp/rzq-smoke.log; then
  echo "Smoke run failed — output:"; cat /tmp/rzq-smoke.log; exit 1
fi
kill "$SMOKE_PID" 2>/dev/null || true
echo "Smoke run OK: $(grep -a build= /tmp/rzq-smoke.log)"

echo "--- Artifacts ---"
sha256sum "$WEB_DIR"/index.* "$LINUX_DIR/rzq-kids" "$LINUX_DIR/rzq-kids.pck" "$APK_DIR"/*.apk
echo "Build ID: $BUILD_ID"
