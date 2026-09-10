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
const PAIRING_SCENE := preload("res://scenes/entry/pairing.tscn")

enum State { BOOT, LOADING_HOME, HOME, STARTING, LESSON, PAIRING, EXITING }

var _client: PLATFORM_BASE
var _state: State = State.BOOT
var _home: Control
var _lesson: Control
var _pairing: Control
var _bootstrap: Dictionary = {}
var _active_session: Dictionary = {}
var _seq: int = 0

# Lesson-flow state (server-driven; never derived locally).
var _units: Array = []
var _unit_index: int = 0
var _last_sequence: int = 0
var _completed: Dictionary = {}          # unit_id -> true
var _first_answer_stats := {"count": 0, "correct": 0}

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
	_lesson.next_requested.connect(_on_example_next)
	_lesson.check_requested.connect(_on_check_pressed)
	_lesson.continue_after_feedback_requested.connect(_on_feedback_continue)
	_lesson.retry_lesson_requested.connect(_on_retry_lesson)
	_lesson.home_requested.connect(_on_back_to_home)
	_pairing = PAIRING_SCENE.instantiate()
	_pairing.exit_pressed.connect(_on_exit_pressed)
	_pairing.retry_pressed.connect(_on_pairing_retry)
	if _client.has_signal("pairing_code_required"):
		_client.pairing_code_required.connect(_on_pairing_code_required)
	add_child(_home)
	add_child(_lesson)
	add_child(_pairing)
	_home.visible = true
	_lesson.visible = false
	_pairing.visible = false
	# Deferred: during _ready the tree is still setting up children, so any
	# HTTPRequest added inside the transport would fail to enter the tree.
	_load_home.call_deferred()


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
		# Native transport without a grant: enter the staging pairing flow
		# (U02) instead of a dead end. Web never sees GRANT_REQUIRED.
		if result.error_code == "GRANT_REQUIRED" and "pair_and_acquire_grant" in _client:
			_start_pairing()
			return
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
	_state = State.LESSON
	var lesson: Dictionary = _bootstrap.get("lesson", {}) as Dictionary
	var lesson_result: PLATFORM_BASE.Result = await _client.get_lesson(str(lesson.get("lesson_id", "")))
	if _state != State.LESSON:
		return
	if not lesson_result.ok:
		_home.visible = true
		_home.show_error(_message_for(lesson_result.error_code))
		_state = State.HOME
		return
	_units = lesson_result.data.get("units", []) if typeof(lesson_result.data.get("units")) == TYPE_ARRAY else []
	_last_sequence = int(_active_session.get("last_sequence", 0))
	_completed = {}
	for unit_id in _active_session.get("completed_unit_ids", []):
		_completed[str(unit_id)] = true
	_first_answer_stats = {"count": 0, "correct": 0}
	_unit_index = 0
	_lesson.visible = true
	_advance_to_current_unit()


## Jump to the first required unit the server has not recorded as complete.
func _advance_to_current_unit() -> void:
	while _unit_index < _units.size():
		var unit: Dictionary = _units[_unit_index]
		if bool(unit.get("required", false)) and not _completed.has(str(unit.get("unit_id", ""))):
			break
		_unit_index += 1
	if _unit_index >= _units.size():
		_finish_lesson()
		return
	_render_current_unit()


func _render_current_unit() -> void:
	var unit: Dictionary = _units[_unit_index]
	var lesson: Dictionary = _bootstrap.get("lesson", {}) as Dictionary
	_lesson.show_header({
		"title": str(lesson.get("title", "")),
		"content_mode": str(_bootstrap.get("content_mode", "")),
		"step": _unit_index + 1,
		"total": _units.size(),
		"percent": _practice_percent(),
	})
	var unit_type := str(unit.get("unit_type", ""))
	if unit_type == "letter":
		_lesson.show_example({
			"glyph": str(unit.get("letter", "")),
			"label": _label_for_glyph(str(unit.get("letter", ""))),
			"instruction": str(unit.get("instruction", "")),
		})
	elif unit_type == "choice":
		var question: Dictionary = _active_session.get("current_question", {}) if typeof(_active_session.get("current_question")) == TYPE_DICTIONARY else {}
		if question.is_empty():
			# Refresh server state: the current question may have moved on.
			var refreshed: PLATFORM_BASE.Result = await _client.get_session(str(_active_session.get("session_id", "")))
			if _state != State.LESSON:
				return
			if refreshed.ok:
				_active_session = refreshed.data
				_last_sequence = int(_active_session.get("last_sequence", _last_sequence))
				question = _active_session.get("current_question", {}) if typeof(_active_session.get("current_question")) == TYPE_DICTIONARY else {}
		if question.is_empty():
			# A choice unit with no live question is already answered: ack it.
			_ack_current_unit()
			return
		_lesson.show_question({
			"prompt": str(question.get("prompt", "")),
			"options": question.get("options", []),
		})
	elif unit_type == "instruction":
		# Non-required instructions pass through without a server event.
		_unit_index += 1
		_advance_to_current_unit()


## Fixture glyph -> Indonesian label (display only; the fixture is the only
## content where glyphs are shapes today). Reviewed letters keep their unit
## instruction text verbatim instead.
func _label_for_glyph(glyph: String) -> String:
	match glyph:
		"●":
			return "Lingkaran"
		"■":
			return "Persegi"
		"▲":
			return "Segitiga"
	return ""


func _practice_percent() -> float:
	var required := 0
	var done := 0
	for unit in _units:
		if bool(unit.get("required", false)):
			required += 1
			if _completed.has(str(unit.get("unit_id", ""))):
				done += 1
	return 100.0 * done / required if required > 0 else 0.0


## Example "Berikutnya": acknowledge the unit server-side, then advance.
func _on_example_next() -> void:
	if _state != State.LESSON:
		return
	_ack_current_unit()


func _ack_current_unit() -> void:
	var unit: Dictionary = _units[_unit_index]
	var unit_id := str(unit.get("unit_id", ""))
	_last_sequence += 1
	var event := {
		"event_id": _new_event_id(),
		"sequence": _last_sequence,
		"client_at": null,
		"type": "unit_acknowledged",
		"unit_id": unit_id,
	}
	var result: PLATFORM_BASE.Result = await _client.submit_events(str(_active_session.get("session_id", "")), [event])
	if _state != State.LESSON:
		return
	if not result.ok:
		if result.error_code == "EVENT_SEQUENCE_CONFLICT":
			# Server cursor moved (retry after ambiguous network): refetch and
			# re-ack with a fresh key — the stored result is authoritative.
			var refreshed: PLATFORM_BASE.Result = await _client.get_session(str(_active_session.get("session_id", "")))
			if refreshed.ok:
				_active_session = refreshed.data
				_last_sequence = int(_active_session.get("last_sequence", _last_sequence))
				_completed.clear()
				for uid in _active_session.get("completed_unit_ids", []):
					_completed[str(uid)] = true
				_advance_to_current_unit()
				return
		_home.visible = true
		_lesson.visible = false
		_home.show_error(_message_for(result.error_code))
		_state = State.HOME
		return
	_completed[unit_id] = true
	_unit_index += 1
	_advance_to_current_unit()


## Question "Periksa": submit the selected answer; the server evaluates.
func _on_check_pressed() -> void:
	if _state != State.LESSON:
		return
	var option_id: String = _lesson.selected_option()
	if option_id.is_empty():
		return
	var question: Dictionary = _active_session.get("current_question", {}) if typeof(_active_session.get("current_question")) == TYPE_DICTIONARY else {}
	if question.is_empty():
		return
	_lesson.set_submitting(true)
	var result: PLATFORM_BASE.Result = await _client.submit_attempt(
		str(_active_session.get("session_id", "")),
		str(question.get("question_id", "")),
		option_id,
		_new_event_id(),
	)
	if _state != State.LESSON:
		return
	_lesson.set_submitting(false)
	if not result.ok:
		# Keep the selection; retry uses the same server semantics.
		_lesson.show_question({
			"prompt": str(question.get("prompt", "")),
			"options": question.get("options", []),
		})
		push_warning("[rzq-kids] answer failed: " + result.error_code)
		return
	_last_sequence = int(result.data.get("sequence", _last_sequence))
	var correct: bool = bool(result.data.get("correct", false))
	_first_answer_stats["count"] = int(_first_answer_stats["count"]) + 1
	if bool(result.data.get("first_response", true)) and correct:
		_first_answer_stats["correct"] = int(_first_answer_stats["correct"]) + 1
	_lesson.show_feedback({ "correct": correct, "first": bool(result.data.get("first_response", true)) })


## Feedback "Berikutnya": ack the round unit (completion is ack-based) and
## continue; the last round finishes the lesson.
func _on_feedback_continue() -> void:
	if _state != State.LESSON:
		return
	# The round's question is consumed; clear so the next choice unit refetches.
	_active_session["current_question"] = {}
	_ack_current_unit()


## All required units acknowledged: server-confirmed finish + result screen.
func _finish_lesson() -> void:
	var result: PLATFORM_BASE.Result = await _client.finish_session(str(_active_session.get("session_id", "")), _new_request_key())
	if _state != State.LESSON:
		return
	if not result.ok:
		if result.error_code == "INCOMPLETE_SESSION":
			# Server says something is missing: resync from server truth.
			var refreshed: PLATFORM_BASE.Result = await _client.get_session(str(_active_session.get("session_id", "")))
			if refreshed.ok:
				_active_session = refreshed.data
				_last_sequence = int(_active_session.get("last_sequence", _last_sequence))
				_completed.clear()
				for uid in _active_session.get("completed_unit_ids", []):
					_completed[str(uid)] = true
				_unit_index = 0
				_advance_to_current_unit()
				return
		_home.visible = true
		_lesson.visible = false
		_home.show_error(_message_for(result.error_code))
		_state = State.HOME
		return
	_active_session = {}
	_lesson.show_header({ "title": "", "content_mode": str(_bootstrap.get("content_mode", "")), "step": 0, "total": 0, "percent": 100.0 })
	_lesson.show_result({
		"count": int(_first_answer_stats["count"]),
		"correct": int(_first_answer_stats["correct"]),
		"total": 3,
	})


## Result "Coba lagi": a new attempt is a NEW session, never a rewrite.
func _on_retry_lesson() -> void:
	if _state != State.LESSON:
		return
	_state = State.STARTING
	_home.set_busy(true)
	var lesson: Dictionary = _bootstrap.get("lesson", {}) as Dictionary
	var result: PLATFORM_BASE.Result = await _client.start_session(str(lesson.get("lesson_id", "")), _new_request_key())
	if _state != State.STARTING:
		return
	_home.set_busy(false)
	if not result.ok:
		_home.visible = true
		_lesson.visible = false
		_home.show_error(_message_for(result.error_code))
		_state = State.HOME
		return
	_active_session = result.data
	_enter_lesson()


func _new_event_id() -> String:
	return "%s-%s" % [_new_request_key(), Time.get_ticks_usec()]


## Back from the lesson: an unfinished session stays server-side (the home
## then offers "Lanjutkan"); state is refetched, never assumed.
func _on_back_to_home() -> void:
	if _state != State.LESSON:
		return
	_state = State.HOME
	_load_home()


## Staging pairing (native only): shows the human code and waits for the
## allowlisted parent's approval, then re-enters the normal home load.
func _start_pairing() -> void:
	_state = State.PAIRING
	_home.visible = false
	_lesson.visible = false
	_pairing.visible = true
	_pairing.show_waiting()
	_pairing.set_retry_busy(true)
	var result: PLATFORM_BASE.Result = await _client.call("pair_and_acquire_grant")
	if _state != State.PAIRING:
		return
	if result.ok:
		print("[rzq-kids][pairing] grant acquired")
		_pairing.visible = false
		_load_home()
		return
	_pairing.set_retry_busy(false)
	_pairing.show_failed(_message_for(result.error_code))


func _on_pairing_retry() -> void:
	if _state == State.PAIRING:
		_start_pairing()


func _on_pairing_code_required(human_code: String, expires_at: String, pairing_id: String) -> void:
	_pairing.show_code(human_code, expires_at, pairing_id)
	if OS.is_debug_build():
		# Dev aid only: the code alone cannot redeem anything without the
		# verifier, which never leaves native memory.
		print("[rzq-kids][pairing] code=%s pairing_id=%s" % [human_code, pairing_id])


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
		"PAIRING_DENIED":
			return COPY.PAIRING_DENIED
		"PAIRING_EXPIRED", "PAIRING_TIMEOUT":
			return COPY.PAIRING_EXPIRED_CODE
		"GRANT_REQUIRED", "GRANT_INVALID":
			# Staging grant ended (expiry/revocation): restart flow from home.
			return COPY.SESSION_EXPIRED
		_:
			return COPY.CONTENT_UNAVAILABLE
