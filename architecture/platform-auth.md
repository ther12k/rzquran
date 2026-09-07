---
type: Security Architecture
title: Platform adapters and staging-only native pairing
description: Explicit web/native authentication and lifecycle contracts with production exclusion.
tags:
- rz-quran-kids
- godot-mvp
status: draft
generated:
  by: chatgpt/rzq-godot-mvp-1.0
  at: '2026-09-07T07:53:44Z'
sources:
- id: bridge
  resource: https://docs.godotengine.org/en/stable/classes/class_javascriptbridge.html
  title: Godot — JavaScriptBridge
- id: http
  resource: https://docs.godotengine.org/en/stable/tutorials/networking/http_request_class.html
  title: Godot — Making HTTP requests
- resource: /references/project-context.md
  title: User requirements and reported project baseline
x_rzq:
  bundle_version: '1.0'
  review_state: unreviewed
  language: en
  ui_language: id
---

# Platform boundary

## Browser

Embed the exported runtime under a same-origin `/kids-runtime/<build-id>/` path controlled by the React application. A fixed host adapter handles `bootstrap`, `start_session`, `get_session`, `submit_attempt`, `finish_session`, `abandon_session`, `get_media`, and `exit`.

Each message has `protocol_version`, `request_id`, `runtime_nonce`, `action`, and validated `payload`. The host validates the exact origin and sender window, nonce, schema, action allowlist, and a 64 KiB JSON limit. Return correlated responses. Media bytes use a bounded transferable buffer, not JSON/base64 or arbitrary URLs. No caller-supplied URL, JavaScript, HTML, SQL, or path is evaluated. The game receives no browser session cookie value or CSRF secret.

The host retains runtime callbacks for their lifetime and clears them on teardown. JavaScriptBridge is available only in web exports; implementation details remain in the web adapter.[^bridge]

A same-origin iframe is **not** a security isolation boundary against malicious same-origin code. These checks prevent accidental/cross-window misuse, but parent-only actions still require independent server authorization and a fresh parent gate. Keep runtime dependencies and content inputs trusted, constrained and sanitized.

## Android internal entry

Use a short-lived, parent-approved **staging grant**; this is an explicitly limited custom internal flow, not a claim of OAuth compliance or production login readiness.

1. Native generates 32 random bytes using the engine's cryptographic RNG as `code_verifier`; base64url without padding. Send its SHA-256 base64url `code_challenge` to create a pairing.
2. Server returns random `pairing_id`, an 8-character human code from an unambiguous alphabet, `expires_at` five minutes ahead, and `poll_interval_seconds: 5`. Store only hashes of human codes and secrets. Never include profile data before approval.
3. An already authenticated, allowlisted staging parent enters that code on a fixed web route. Existing recent parent reauthentication and profile ownership checks apply. The parent explicitly selects a synthetic profile and sees the environment/device-session scope before approving.
4. Native polls the token endpoint with pairing ID and verifier no faster than the specified interval. The server verifies the challenge before looking up/returning sensitive state. Throttle by pairing and network source; wrong verifier receives a neutral error.
5. Once approved, issue an opaque random 256-bit access token, hashed at rest, with audience `rzq-kids-staging`, the selected profile, lesson allowlist, client/build ID, and a maximum 15-minute expiry. Keep it only in native memory. No refresh token or persistent login in this MVP.
6. Logout clears local memory and attempts server revocation. Server expiry, parent revocation, profile deletion, content recall and disabled environment invalidate access independently of client cooperation.

Pairing ID alone cannot redeem a token. Token redemption is one-use; a network failure after successful redemption restarts pairing instead of issuing a second token. Polling is bounded; 429 exposes retry delay. Code-entry attempts are limited (initial engineering limits: 5 failures per minute per parent and network source, plus a bounded pairing-wide attempt count). GDM-004 must verify combined/rate-distributed behavior and document the final configuration.

Production must neither issue these grants nor accept their audience; enforce this in middleware and a separate production-mode test. Editing APK config or replaying a staging token at production must fail. Pairing-enabled staging must not contain real child profiles until an explicitly reviewed scope change.

## Session lifetime

The lesson expires at the earlier of 15 minutes from creation or native grant expiry. Browser context uses existing adult session lifetime but the lesson still has a 15-minute cap. Server invalidation is authoritative. Background/resume always refetches status before allowing another answer. No cached offline answer queue survives process death, profile switch, or logout.

## HTTP/media

Native uses HTTPS with certificate verification. Android requires the Internet permission to use the network; do not add microphone, camera, contacts, location, or broad storage permissions.[^http] Use the existing API media gateway; native has an exact origin allowlist and does not follow cross-origin redirects with credentials.

Return `Cache-Control: no-store` for child context, grant, session and private media responses. No sensitive tokens in URLs, crash logs, screenshots, clipboard helpers or import docs. Prefer fresh pairing after restart over introducing unsafe storage to reduce friction in internal testing.

[^bridge]: Godot — JavaScriptBridge.

[^http]: Godot — Making HTTP requests.
