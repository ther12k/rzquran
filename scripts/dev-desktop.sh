#!/usr/bin/env bash
# Dev convenience launcher (LOCAL DEVELOPMENT ONLY — never for production):
# starts the desktop build against the local API and auto-approves the
# staging pairing as the allowlisted test parent. The pairing flow itself is
# unchanged; this only automates the parent's code entry for dev runs.
set -euo pipefail
HERE="$(cd "$(dirname "$0")/.." && pwd)"
API_BASE="${RZQ_API_BASE:-http://127.0.0.1:3310}"
ORIGIN="${RZQ_DEV_ORIGIN:-http://localhost:5175}"
EMAIL="${RZQ_DEV_PARENT:-tester@rzq.local}"
PASS="${RZQ_DEV_PASS:-kata-sandi-aman-123}"
CHILD_ID="${RZQ_DEV_CHILD:-}"   # defaults to the parent's first profile

command -v curl >/dev/null || { echo "curl required" >&2; exit 1; }

LOG="${TMPDIR:-/tmp}/rzq-desktop.log"
: > "$LOG"

echo "[dev-desktop] launching game (API: $API_BASE) …"
DISPLAY="${DISPLAY:-:1}" RZQ_API_BASE="$API_BASE" "$HERE/build/kids-linux/rzq-kids" >"$LOG" 2>&1 &
GAME_PID=$!
trap 'kill "$GAME_PID" 2>/dev/null || true' EXIT

CODE=""; PAIRING=""
for _ in $(seq 1 30); do
  CODE=$(grep -aoE 'code=[A-Z2-9]{8}' "$LOG" | head -1 | cut -d= -f2 || true)
  PAIRING=$(grep -aoE 'pairing_id=[0-9a-f-]{36}' "$LOG" | head -1 | cut -d= -f2 || true)
  [ -n "$CODE" ] && [ -n "$PAIRING" ] && break
  sleep 1
done
[ -n "$CODE" ] || { echo "[dev-desktop] no pairing code appeared; game log:" >&2; tail -5 "$LOG" >&2; exit 1; }
echo "[dev-desktop] pairing code: $CODE"

COOKIE=$(mktemp)
sign_in() {
  curl -s -c "$COOKIE" -b "$COOKIE" -X POST "$ORIGIN/api/auth/sign-in/email" \
    -H "Content-Type: application/json" -H "Origin: $ORIGIN" \
    -d "{\"email\":\"$EMAIL\",\"password\":\"$PASS\"}" >/dev/null
  curl -s -c "$COOKIE" -b "$COOKIE" -X POST "$ORIGIN/api/v1/parent/gate" \
    -H "Content-Type: application/json" -H "Origin: $ORIGIN" \
    -d "{\"password\":\"$PASS\"}" >/dev/null
}
sign_in

if [ -z "$CHILD_ID" ]; then
  CHILD_ID=$(curl -s -b "$COOKIE" "$ORIGIN/api/v1/parent/children" -H "Origin: $ORIGIN" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["items"][0]["id"])')
fi

for ATTEMPT in 1 2 3; do
  RES=$(curl -s -b "$COOKIE" -X POST "$ORIGIN/api/v1/parent/kids/pairings/approve" \
    -H "Content-Type: application/json" -H "Origin: $ORIGIN" -H "X-Forwarded-For: 127.0.0.1" \
    -d "{\"pairing_id\":\"$PAIRING\",\"code\":\"$CODE\",\"child_id\":\"$CHILD_ID\",\"decision\":\"approve\"}")
  echo "[dev-desktop] approve: $RES"
  echo "$RES" | grep -q '"status":"approved"' && break
  # Code may have expired: a new pairing is created on retry only by the game;
  # wait for a fresh code line and retry with it.
  sleep 3
  NEW=$(grep -aoE 'code=[A-Z2-9]{8}' "$LOG" | tail -1 | cut -d= -f2 || true)
  NEWP=$(grep -aoE 'pairing_id=[0-9a-f-]{36}' "$LOG" | tail -1 | cut -d= -f2 || true)
  [ -n "$NEW" ] && CODE="$NEW"
  [ -n "$NEWP" ] && PAIRING="$NEWP"
done

# Stay attached while the game runs; the window closes with Ctrl+C here.
wait "$GAME_PID"
