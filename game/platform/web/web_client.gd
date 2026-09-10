extends "res://platform/platform_client.gd"
## Web adapter: same-origin host bridge (JavaScriptBridge), per
## docs/godot-mvp/architecture/platform-auth.md. Loaded ONLY by the
## composition root on the web platform.
##
## Transport: the runtime posts {rzq_bridge:1, protocol_version, request_id,
## runtime_nonce, action, payload} envelopes to the host window; the host
## performs all authenticated fetches (cookies stay host-side) and posts
## correlated responses back. The nonce is minted by the host page and echoed
## on every request. All methods are awaitable (GDScript coroutines) and return
## typed PlatformClient.Result values; nothing here touches cookies, CSRF, or
## arbitrary URLs.

const PROTOCOL_VERSION := "1"
const REQUEST_TIMEOUT_MS := 15000

var _js_window: JavaScriptObject
# Strong GDScript-side reference: a create_callback() only held by JS can be
# garbage collected by Godot, after which calls into it silently no-op.
var _js_callback: JavaScriptObject
var _nonce: String = ""
var _seq: int = 0
var _responses: Dictionary = {}

var _installed: bool = false


func platform_name() -> String:
	return "web-host-bridge"


func _ensure_installed() -> void:
	if _installed or not OS.has_feature("web"):
		return
	_js_window = JavaScriptBridge.get_interface("window")
	var nonce_variant: Variant = JavaScriptBridge.eval(
		"new URLSearchParams(window.location.search).get('rzq_nonce') ?? ''", true)
	_nonce = str(nonce_variant)
	# Install the forwarder + listener once (host page may persist across runs).
	# The game→host envelope crosses as a JSON STRING: GDScript Dictionary
	# arguments do not marshal through the JSObject interface call, but
	# strings do (verified live — objects arrived mangled and were rejected).
	JavaScriptBridge.eval("""
(function () {
  if (window.__rzqBridgeInstalled) return;
  window.__rzqBridgeInstalled = true;
  window.rzqFromGodot = function (raw) {
    try {
      var msg = typeof raw === "string" ? JSON.parse(raw) : raw;
      window.parent.postMessage(msg, window.location.origin);
    } catch (e) {}
  };
  window.addEventListener("message", function (e) {
    if (e.origin !== window.location.origin) return;
    var d = e.data;
    console.log("[rzq-kids][fwd] iframe got message bridge=" + (d && d.rzq_bridge) + " req=" + (d && d.request_id));
    if (!d || d.rzq_bridge !== 1) return;
    if (!window.rzqToGodot) { console.log("[rzq-kids][fwd] rzqToGodot MISSING"); return; }
    if (d.buffer instanceof ArrayBuffer) {
      window.rzqToGodot(JSON.stringify({
        rzq_bridge: 1, request_id: d.request_id, ok: d.ok,
        data: d.data, error: d.error
      }), d.buffer);
    } else {
      window.rzqToGodot(JSON.stringify(d));
    }
  });
})();
""", true)
	var callback := JavaScriptBridge.create_callback(_on_js_message)
	_js_callback = callback
	_js_window.rzqToGodot = callback
	_installed = true


func _on_js_message(args: Array) -> void:
	print("[rzq-kids][bridge] recv args=", args.size())
	if args.is_empty():
		return
	var raw: Variant = args[0]
	if typeof(raw) != TYPE_STRING:
		return
	var parsed: Variant = JSON.parse_string(str(raw))
	if typeof(parsed) != TYPE_DICTIONARY:
		return
	var msg: Dictionary = parsed
	var request_id := str(msg.get("request_id", ""))
	if request_id.is_empty():
		return
	var buffer: Variant = args[1] if args.size() > 1 else null
	_responses[request_id] = { "msg": msg, "buffer": buffer }


func _request(action: String, payload: Dictionary = {}) -> Result:
	_ensure_installed()
	if not OS.has_feature("web"):
		return fail("WEB_ONLY")
	if _nonce.is_empty():
		push_warning("[rzq-kids][bridge] nonce empty; cannot send " + action)
		return fail("BRIDGE_NONCE_MISSING")
	_seq += 1
	var request_id := "%s-%d" % [_nonce.substr(0, 8), _seq]
	var msg := {
		"rzq_bridge": 1,
		"protocol_version": PROTOCOL_VERSION,
		"request_id": request_id,
		"runtime_nonce": _nonce,
		"action": action,
	}
	if not payload.is_empty():
		msg["payload"] = payload

	var tree := Engine.get_main_loop() as SceneTree
	if tree == null:
		return fail("NO_MAIN_LOOP")
	print("[rzq-kids][bridge] send action=%s id=%s nonce_len=%d" % [action, request_id, _nonce.length()])
	# JSON string, not a Dictionary: dictionaries do not marshal through the
	# JSObject interface call (see forwarder note in _ensure_installed).
	_js_window.rzqFromGodot(JSON.stringify(msg))

	var deadline := Time.get_ticks_msec() + REQUEST_TIMEOUT_MS
	while not _responses.has(request_id):
		if Time.get_ticks_msec() > deadline:
			_responses.erase(request_id)
			return fail("NETWORK_TIMEOUT")
		await tree.process_frame

	var entry: Dictionary = _responses[request_id]
	_responses.erase(request_id)
	var response: Dictionary = entry["msg"]
	if bool(response.get("ok", false)):
		var data: Dictionary = {}
		var raw_data: Variant = response.get("data")
		if typeof(raw_data) == TYPE_DICTIONARY:
			data = raw_data
		var buffer: Variant = entry["buffer"]
		if buffer != null:
			data["bytes"] = buffer
		return ok(data)
	var error: Dictionary = response.get("error", {}) if typeof(response.get("error")) == TYPE_DICTIONARY else {}
	return fail(str(error.get("code", "BRIDGE_ERROR")))


func bootstrap() -> Result:
	return await _request("bootstrap")


func get_lesson(lesson_id: String) -> Result:
	return await _request("get_lesson", { "lesson_id": lesson_id })


func submit_events(session_id: String, events: Array) -> Result:
	return await _request("submit_events", { "session_id": session_id, "events": events })


func start_session(lesson_id: String, _request_id: String) -> Result:
	# Idempotency is host-side (Idempotency-Key); the payload carries ids only.
	return await _request("start_session", { "lesson_id": lesson_id })


func get_session(session_id: String) -> Result:
	return await _request("get_session", { "session_id": session_id })


func submit_attempt(session_id: String, question_id: String, option_id: String, event_id: String) -> Result:
	return await _request("submit_attempt", {
		"session_id": session_id,
		"question_id": question_id,
		"selected_option_id": option_id,
		"event_id": event_id,
	})


func finish_session(session_id: String, _request_id: String) -> Result:
	return await _request("finish_session", { "session_id": session_id })


func abandon_session(session_id: String, _request_id: String) -> Result:
	return await _request("abandon_session", { "session_id": session_id })


func fetch_media(session_id: String, asset_id: String) -> Result:
	return await _request("get_media", { "session_id": session_id, "asset_id": asset_id })


func exit_runtime() -> Result:
	var result := await _request("exit")
	# Host disposes callbacks after exit; drop local pending state too.
	_responses.clear()
	return result
