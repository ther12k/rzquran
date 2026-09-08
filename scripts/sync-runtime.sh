#!/usr/bin/env bash
# Sync the built Godot web export into the rz-quran web app so the bridge host
# page can serve it same-origin under /kids-runtime/ (GDM-008).
# Run AFTER scripts/build-kids.sh. Output dir is gitignored in rz-quran.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SRC_DIR="$REPO_ROOT/build/kids-web"
DEST_DIR="${RZQ_WEB_ROOT:-$REPO_ROOT/../rz-quran}/apps/web/public/kids-runtime"

if [[ ! -f "$SRC_DIR/index.html" ]]; then
  echo "Web export not found: $SRC_DIR/index.html (run scripts/build-kids.sh first)" >&2
  exit 1
fi

mkdir -p "$DEST_DIR"
cp -f "$SRC_DIR"/* "$DEST_DIR"/
echo "Synced $(ls "$SRC_DIR" | wc -l) files -> $DEST_DIR"
