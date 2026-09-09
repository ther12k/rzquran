extends "res://platform/platform_client.gd"
## Native adapter: direct HTTPS to the existing API with the staging-only
## grant flow, per docs/godot-mvp/architecture/platform-auth.md. Loaded ONLY
## by the composition root on non-web platforms.
##
## Transport: one HTTPRequest per call (15 s timeout), TLS verification left
## at engine defaults. The staging grant (opaque 256-bit token) is issued via
## verifier-bound pairing (S256) plus an allowlisted parent's approval of a
## synthetic profile, and lives ONLY in this object's memory — never in
## files, Settings, or logs. No refresh token exists; a lost redemption
## response restarts pairing instead of re-issuing.
##
## Environment:
##   RZQ_API_BASE            API origin (default http://127.0.0.1:3000 for
##                           local dev; staging deploys set an https URL).
##   RZQ_CLIENT_BUILD_ID     client/build id bound into the pairing+grant.
##
## Polling is bounded: the client waits at most until pairing expiry
## (5 minutes), never polling faster than the server-specified interval.

const PAIRING_PATH := "/api/v1/kids/pairings"
const TOKEN_PATH := "/api/v1/kids/pairings/token"
const SELF_REVOKE_PATH := "/api/v1/kids/grants/revoke_current"
const POLL_INTERVAL_FLOOR_S := 5.0
const REQUEST_TIMEOUT_S := 15.0
const VERIFIER_BYTES := 32

signal pairing_code_required(human_code: String, expires_at: String, pairing_id: String)
signal pairing_finished(status: String)

var _api_base: String = ""
var _client_build_id: String = ""
var _access_token: String = ""
var _grant_expires_at_ms: int = 0
var _profile: Dictionary = {}


func platform_name() -> String:
	return "native-https"


func grant_active() -> bool:
	return not _access_token.is_empty() and Time.get_ticks_msec() < _grant_expires_at_ms


func profile() -> Dictionary:
	return _profile.duplicate(true)


## Staging pairing flow: returns ok({status:"approved", profile:…}) on
## success, or fail(code) with PAIRING_* codes. Never persists anything.
func pair_and_acquire_grant() -> Result:
	_load_env()
	var crypto := Crypto.new()
	var verifier_bytes: PackedByteArray = crypto.generate_random_bytes(VERIFIER_BYTES)
	var verifier: String = _b64url(verifier_bytes)
	# RFC 7636 S256: challenge = base64url(SHA256(ASCII(code_verifier))) —
	# the STRING is hashed, not the raw bytes (server re-hashes the string).
	var hasher := HashingContext.new()
	hasher.start(HashingContext.HASH_SHA256)
	hasher.update(verifier.to_utf8_buffer())
	var challenge: String = _b64url(hasher.finish())

	var created := await _json_request(HTTPClient.METHOD_POST, PAIRING_PATH, {
		"code_challenge": challenge,
		"client_build_id": _client_build_id,
	}, {})
	if not created.ok:
		return created
	var pairing_id := str(created.data.get("pairing_id", ""))
	var human_code := str(created.data.get("human_code", ""))
	var expires_at := str(created.data.get("expires_at", ""))
	var poll_interval := maxf(float(created.data.get("poll_interval_seconds", 5)), POLL_INTERVAL_FLOOR_S)
	if pairing_id.is_empty() or human_code.is_empty():
		return fail("PAIRING_INVALID")

	# Surface the code; the allowlisted parent enters it on the fixed web route.
	emit_signal("pairing_code_required", human_code, expires_at, pairing_id)

	var deadline_ms := Time.get_ticks_msec() + int(POLL_INTERVAL_FLOOR_S * 1000.0 * 60.0)
	while Time.get_ticks_msec() < deadline_ms:
		await _sleep(poll_interval)
		var poll := await _json_request(HTTPClient.METHOD_POST, TOKEN_PATH, {
			"pairing_id": pairing_id,
			"code_verifier": verifier,
		}, {})
		if not poll.ok:
			# RATE_LIMITED and network noise: keep waiting politely.
			if poll.error_code == "RATE_LIMITED":
				continue
			return poll
		var status := str(poll.data.get("status", ""))
		if status == "pending":
			continue
		emit_signal("pairing_finished", status)
		if status != "approved":
			# denied/expired → restart pairing (one-use redemption is final).
			return fail("PAIRING_" + status.to_upper())
		_store_grant(poll.data, poll_interval)
		return ok({ "status": "approved", "profile": _profile.duplicate(true) })
	return fail("PAIRING_TIMEOUT")


func logout() -> void:
	# Best-effort server revocation, then unconditional memory wipe (P5).
	if grant_active():
		var _revoked: Result = await _json_request(HTTPClient.METHOD_POST, SELF_REVOKE_PATH, {}, {})
	_access_token = ""
	_grant_expires_at_ms = 0
	_profile = {}


# --- PlatformClient surface (bearer transport, same scoped lesson routes) ---

func bootstrap() -> Result:
	var current := await _authorized_json(HTTPClient.METHOD_GET, "/api/v1/learning/current", {}, {})
	if not current.ok:
		return current
	var catalog := await _authorized_json(HTTPClient.METHOD_GET, "/api/v1/catalog", {}, {})
	if not catalog.ok:
		return catalog
	var lesson := {}
	for item in catalog.data.get("items", []):
		if item is Dictionary and str(item.get("access", "")) == "available":
			lesson = item
			break
	var fixture: bool = bool(lesson.get("demo_only", false))
	return ok({
		"contract_version": "1",
		"content_mode": "fixture" if fixture else "reviewed_learning",
		"profile": _profile,
		"lesson": lesson,
		"active_session": current.data.get("session"),
		"server_time": "%sZ" % Time.get_datetime_string_from_system(true),
	})


func start_session(lesson_id: String, request_id: String) -> Result:
	return await _authorized_json(HTTPClient.METHOD_POST, "/api/v1/learning/sessions", { "lesson_id": lesson_id }, { "Idempotency-Key": request_id })


func get_session(session_id: String) -> Result:
	return await _authorized_json(HTTPClient.METHOD_GET, "/api/v1/learning/sessions/%s" % session_id, {}, {})


func submit_attempt(session_id: String, question_id: String, option_id: String, event_id: String) -> Result:
	return await _authorized_json(HTTPClient.METHOD_POST, "/api/v1/learning/sessions/%s/answers" % session_id, {
		"question_id": question_id,
		"selected_option_id": option_id,
		"event_id": event_id,
	}, {})


func finish_session(session_id: String, request_id: String) -> Result:
	return await _authorized_json(HTTPClient.METHOD_POST, "/api/v1/learning/sessions/%s/finish" % session_id, {}, { "Idempotency-Key": request_id })


func abandon_session(session_id: String, request_id: String) -> Result:
	return await _authorized_json(HTTPClient.METHOD_POST, "/api/v1/learning/sessions/%s/abandon" % session_id, {}, { "Idempotency-Key": request_id })


func fetch_media(session_id: String, asset_id: String) -> Result:
	var bytes_result := await _authorized_bytes(HTTPClient.METHOD_GET, "/api/v1/media/stream/%s?session_id=%s" % [asset_id, session_id])
	if not bytes_result.ok:
		return bytes_result
	return ok(bytes_result.data)


func exit_runtime() -> Result:
	# Leaving the runtime drops the grant from memory (server expiry and
	# parent-side revocation remain authoritative independently).
	await logout()
	return ok({})


# --- internals ---------------------------------------------------------------

func _load_env() -> void:
	if _api_base.is_empty():
		_api_base = OS.get_environment("RZQ_API_BASE")
		if _api_base.is_empty():
			_api_base = "http://127.0.0.1:3000"
	if _client_build_id.is_empty():
		_client_build_id = OS.get_environment("RZQ_CLIENT_BUILD_ID")
		if _client_build_id.is_empty():
			_client_build_id = "godot-%s-native" % BuildInfo.build_id


func _store_grant(redemption: Dictionary, _poll_interval: float) -> void:
	_access_token = str(redemption.get("access_token", ""))
	_grant_expires_at_ms = Time.get_ticks_msec() + int(float(redemption.get("expires_in", 0)) * 1000.0)
	var profile_variant: Variant = redemption.get("profile", {})
	_profile = profile_variant if typeof(profile_variant) == TYPE_DICTIONARY else {}


func _new_request_key() -> String:
	var crypto := Crypto.new()
	return _b64url(crypto.generate_random_bytes(16))


## base64url (RFC 4648 §5) without padding — Marshalls only offers the
## standard alphabet, so translate +/ and strip =.
func _b64url(bytes: PackedByteArray) -> String:
	return Marshalls.raw_to_base64(bytes).replace("+", "-").replace("/", "_").rstrip("=")


func _sleep(seconds: float) -> void:
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return
	await tree.create_timer(seconds).timeout


func _json_request(method: int, path: String, body: Dictionary, headers: Dictionary) -> Result:
	var json := JSON.stringify(body)
	var all_headers := { "Content-Type": "application/json" }
	for key in headers:
		all_headers[key] = headers[key]
	var response := await _http(method, path, all_headers, json.to_utf8_buffer())
	if not response.ok:
		return response
	return _decode_json(response.data)


func _authorized_json(method: int, path: String, body: Dictionary, headers: Dictionary) -> Result:
	if not grant_active():
		return fail("GRANT_REQUIRED")
	var with_auth := { "Authorization": "Bearer %s" % _access_token }
	for key in headers:
		with_auth[key] = headers[key]
	var result := await _json_request(method, path, body, with_auth)
	if not result.ok and result.error_code == "HTTP_401":
		# Server invalidation is authoritative; drop the dead grant.
		_access_token = ""
		_grant_expires_at_ms = 0
		_profile = {}
		result.error_code = "GRANT_INVALID"
	return result


func _authorized_bytes(method: int, path: String) -> Result:
	if not grant_active():
		return fail("GRANT_REQUIRED")
	var response := await _http(method, path, { "Authorization": "Bearer %s" % _access_token }, PackedByteArray())
	if not response.ok:
		if response.error_code == "HTTP_401":
			# Server invalidation is authoritative; drop the dead grant.
			_access_token = ""
			_grant_expires_at_ms = 0
			return fail("GRANT_INVALID")
		return response
	var data: Dictionary = response.data
	# Media crosses as raw bytes + MIME, mirroring the web bridge's transfer.
	data["bytes"] = data.get("body", PackedByteArray())
	data["mime_type"] = str(data.get("mime_type", "application/octet-stream"))
	return ok(data)


func _http(method: int, path: String, headers: Dictionary, body: PackedByteArray) -> Result:
	_load_env()
	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return fail("NO_MAIN_LOOP")
	var http := HTTPRequest.new()
	http.timeout = REQUEST_TIMEOUT_S
	http.accept_gzip = true
	tree.root.add_child(http)
	var header_list := PackedStringArray()
	for key in headers:
		header_list.append("%s: %s" % [key, headers[key]])

	var err := http.request_raw(_api_base + path, header_list, method, body)
	if err != OK:
		http.queue_free()
		return fail("NETWORK_ERROR")

	var completed: Array = await http.request_completed
	http.queue_free()
	var result_code: int = completed[0] if completed.size() > 0 else FAILED
	var status_code: int = completed[1] if completed.size() > 1 else 0
	var response_headers: PackedStringArray = completed[2] if completed.size() > 2 else PackedStringArray()
	var response_body: PackedByteArray = completed[3] if completed.size() > 3 else PackedByteArray()

	if result_code != HTTPRequest.RESULT_SUCCESS:
		return fail("NETWORK_TIMEOUT" if result_code == HTTPRequest.RESULT_REQUEST_FAILED else "NETWORK_ERROR")
	if status_code >= 400:
		var fail_result := fail("HTTP_%d" % status_code)
		# Surface the server error code when the body is a JSON envelope.
		var decoded := _decode_json({ "body": response_body })
		if decoded.ok and typeof(decoded.data.get("error")) == TYPE_DICTIONARY:
			var server_error: Dictionary = decoded.data["error"]
			if not str(server_error.get("code", "")).is_empty():
				fail_result.error_code = str(server_error["code"])
		return fail_result
	return ok({
		"status": status_code,
		"body": response_body,
		"mime_type": _extract_content_type(response_headers),
	})


func _decode_json(response: Dictionary) -> Result:
	var raw: PackedByteArray = response.get("body", PackedByteArray())
	if raw.is_empty():
		return ok({})
	var parsed: Variant = JSON.parse_string(raw.get_string_from_utf8())
	if typeof(parsed) != TYPE_DICTIONARY:
		return fail("BAD_RESPONSE")
	return ok(parsed)


func _extract_content_type(headers: PackedStringArray) -> String:
	for header in headers:
		var lowered := header.to_lower()
		if lowered.begins_with("content-type:"):
			return header.substr(13).strip_edges()
	return "application/octet-stream"
