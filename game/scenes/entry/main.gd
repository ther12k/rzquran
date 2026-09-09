extends Control
## Composition root AND lesson state machine (godot-structure.md):
##   BOOT -> LOADING_HOME -> HOME -> STARTING -> LESSON -> (back) HOME,
##   with distinct loading / unavailable / recoverable-error states.
## The ONLY place that selects a platform adapter; scenes depend on the typed
## PlatformClient surface and the display scenes expose signals only.
## References use preload/path, never class_name (see platform_client.gd).

const PLATFORM_BASE := preload("res://platform/platform_client.gd")
const COPY := preload("res://services/copy.gd")
const HOME_SCENE := preload("res://scenes/home/home.tscn")
const LESSON_SCENE := preload("res://scenes/lesson/lesson.tscn")

enum State { BOOT, LOADING_HOME, HOME, STARTING, LESSON, EXITING }

var _client: PLATFORM_BASE
var _state: State = State.BOOT
var _home: Control
var _lesson: Control
var _bootstrap: Dictionary = {}
var _active_session: Dictionary = {}
var _seq: int = 0

@onready var _build_label: Label = %BuildLabel
@onready var _platform_label: Label = %PlatformLabel


func _ready() -> void:
	theme = preload("res://theme/rzq_kids_theme.tres")
	_client = _make_client()
	# Development visibility only (GDM-002); never part of the child UI.
	_build_label.visible = OS.is_debug_build()
	_platform_label.visible = OS.is_debug_build()
	_build_label.text = "Build %s" % BuildInfo.build_id
	_platform_label.text = "Platform: %s" % _client.platform_name()
	print("[rzq-kids] build=%s platform=%s" % [BuildInfo.build_id, _client.platform_name()])
	var w := get_window()
	print("[rzq-kids][win] size=%s content_scale_size=%s content_scale_factor=%.2f" % [w.size, w.content_scale_size, w.content_scale_factor])
	_home = HOME_SCENE.instantiate()
	_home.start_pressed.connect(_on_start_pressed)
	_home.exit_pressed.connect(_on_exit_pressed)
	_home.retry_pressed.connect(_load_home)
	_lesson = LESSON_SCENE.instantiate()
	_lesson.exit_to_home.connect(_on_back_to_home)
	add_child(_home)
	add_child(_lesson)
	_home.visible = true
	_lesson.visible = false
	_load_home()


func _make_client() -> PLATFORM_BASE:
	if OS.has_feature("web"):
		return load("res://platform/web/web_client.gd").new() as PLATFORM_BASE
	return load("res://platform/native/native_client.gd").new() as PLATFORM_BASE


func _new_request_key() -> String:
	_seq += 1
	return "%s-%d" % [BuildInfo.build_id, _seq]


## HOME load / reload: always refetches server state before rendering and
## before any further answer (platform-auth: server invalidation authoritative).
func _load_home() -> void:
	_state = State.LOADING_HOME
	_lesson.visible = false
	_home.visible = true
	_home.show_loading()
	var result: PLATFORM_BASE.Result = await _client.bootstrap()
	if _state != State.LOADING_HOME:
		return
	if not result.ok:
		_home.show_error(_message_for(result.error_code))
		_state = State.HOME
		return
	_bootstrap = result.data
	if str(_bootstrap.get("contract_version", "")) != COPY.CONTRACT_VERSION:
		_home.show_unavailable(COPY.VERSION_UNSUPPORTED)
		_state = State.HOME
		return
	var lesson: Variant = _bootstrap.get("lesson")
	if typeof(lesson) != TYPE_DICTIONARY or (lesson as Dictionary).is_empty():
		_home.show_unavailable(COPY.CONTENT_UNAVAILABLE)
		_state = State.HOME
		return
	var session: Variant = _bootstrap.get("active_session")
	_active_session = {}
	var resumable := false
	if typeof(session) == TYPE_DICTIONARY and ["active", "paused"].has(str((session as Dictionary).get("status", ""))):
		_active_session = session
		resumable = true
	_home.show_home({
		"nickname": str((_bootstrap.get("profile", {}) as Dictionary).get("nickname", "")),
		"content_mode": str(_bootstrap.get("content_mode", "")),
		"lesson": lesson,
		"can_resume": resumable,
	})
	_state = State.HOME


## One clear start/resume action: resumes the server-side session when one is
## active, otherwise opens a new idempotent session.
func _on_start_pressed() -> void:
	if _state != State.HOME:
		return
	_state = State.STARTING
	_home.set_busy(true)
	var session: Dictionary = _active_session
	if session.is_empty():
		var lesson: Dictionary = _bootstrap.get("lesson", {}) as Dictionary
		var result: PLATFORM_BASE.Result = await _client.start_session(str(lesson.get("lesson_id", "")), _new_request_key())
		if _state != State.STARTING:
			return
		if not result.ok:
			_home.set_busy(false)
			_home.show_error(_message_for(result.error_code))
			_state = State.HOME
			return
		session = result.data
	_active_session = session
	_enter_lesson()


func _enter_lesson() -> void:
	_home.visible = false
	var fixture: bool = str(_bootstrap.get("content_mode", "")) == "fixture"
	var lesson: Dictionary = _bootstrap.get("lesson", {}) as Dictionary
	_lesson.show_lesson({
		"title": str(lesson.get("title", "")),
		"content_mode": _bootstrap.get("content_mode", ""),
		"round_label": "",
	})
	_lesson.visible = true
	_state = State.LESSON


## Back from the lesson: an unfinished session stays server-side (the home
## then offers "Lanjutkan"); state is refetched, never assumed.
func _on_back_to_home() -> void:
	if _state != State.LESSON:
		return
	_state = State.HOME
	_load_home()


## Exit must never be obstructed and stops any audio immediately. On web the
## host tears the runtime down after the exit message; on native we quit.
func _on_exit_pressed() -> void:
	if _state == State.EXITING:
		return
	_state = State.EXITING
	var audio := get_node_or_null("/root/AudioService")
	if audio != null and audio.has_method("stop_all"):
		audio.stop_all()
	var _ignored: PLATFORM_BASE.Result = await _client.exit_runtime()
	if not OS.has_feature("web"):
		get_tree().quit()


func _message_for(error_code: String) -> String:
	match error_code:
		"NETWORK_TIMEOUT", "NETWORK_ERROR", "BRIDGE_NONCE_MISSING", "BAD_RESPONSE":
			return COPY.NETWORK_WAIT
		"SESSION_EXPIRED":
			return COPY.SESSION_EXPIRED
		"CONTENT_RECALLED":
			return COPY.CONTENT_RECALLED
		"GRANT_REQUIRED", "GRANT_INVALID":
			# Staging grant ended (expiry/revocation): restart flow from home.
			return COPY.SESSION_EXPIRED
		_:
			return COPY.CONTENT_UNAVAILABLE
