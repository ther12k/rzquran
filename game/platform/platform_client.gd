extends RefCounted
## Typed platform boundary shared by web and native adapters (ADR-001/ADR-002).
## Shared scenes and services depend ONLY on this script, referenced via
## preload/path — NOT via class_name, which depends on the editor's global
## class cache and is not reliably populated in headless exports. Adapters
## extend it by path. Method set follows
## docs/godot-mvp/architecture/godot-structure.md.
##
## Stubs are intentional for the GDM-002 shell: transport wiring arrives with
## GDM-006/008/009. Results are typed values; adapters never hand raw
## dictionaries to UI code.


class Result:
	var ok: bool
	var data: Dictionary
	var error_code: String

	func _init(p_ok: bool, p_data: Dictionary = {}, p_error: String = "") -> void:
		ok = p_ok
		data = p_data
		error_code = p_error


static func ok(data: Dictionary = {}) -> Result:
	return Result.new(true, data)


static func fail(error_code: String) -> Result:
	return Result.new(false, {}, error_code)


func platform_name() -> String:
	push_warning("PlatformClient.platform_name is not implemented by this adapter yet.")
	return "unknown"


func bootstrap() -> Result:
	return _unsupported("bootstrap")


## Public lesson units for the pinned lesson (instructions, glyphs, types).
## Needed by the lesson flow; DTO fields mirror /v1/lessons/:id.
func get_lesson(_lesson_id: String) -> Result:
	return _unsupported("get_lesson")


## Ordered events batch (unit acknowledgments); sequence must be contiguous
## with the server cursor. Events carry only typed DTO fields.
func submit_events(_session_id: String, _events: Array) -> Result:
	return _unsupported("submit_events")


func start_session(_lesson_id: String, _request_id: String) -> Result:
	return _unsupported("start_session")


func get_session(_session_id: String) -> Result:
	return _unsupported("get_session")


func submit_attempt(_session_id: String, _question_id: String, _option_id: String, _request_id: String) -> Result:
	return _unsupported("submit_attempt")


func finish_session(_session_id: String, _request_id: String) -> Result:
	return _unsupported("finish_session")


func abandon_session(_session_id: String, _request_id: String) -> Result:
	return _unsupported("abandon_session")


func fetch_media(_session_id: String, _asset_id: String) -> Result:
	return _unsupported("fetch_media")


func exit_runtime() -> Result:
	return _unsupported("exit_runtime")


func _unsupported(method: String) -> Result:
	push_warning("PlatformClient.%s is not implemented by this adapter yet." % method)
	return fail("NOT_IMPLEMENTED")
