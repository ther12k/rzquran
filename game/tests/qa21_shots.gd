extends Node
## QA-21 scene harness (GDM-011): instantiates the home and lesson scenes,
## drives every distinct state, asserts reflow invariants at target widths
## (360/430 phone, 768 tablet, 1280 desktop, 360x640-landscape phone) and
## saves rendered PNGs for human layout review. Run against a display:
##   godot --path game res://tests/qa21_shots.tscn -- --out ../build/qa21
## Fails (exit 1) if any invariant is violated.

const HOME_SCENE := preload("res://scenes/home/home.tscn")
const LESSON_SCENE := preload("res://scenes/lesson/lesson.tscn")

const WIDTHS := [
	Vector2i(360, 640),   # small phone portrait
	Vector2i(430, 800),   # large phone portrait
	Vector2i(768, 900),   # tablet portrait
	Vector2i(1280, 800),  # desktop
	Vector2i(640, 360),   # phone landscape (usable via scroll, not cropped)
]

var _failures: Array[String] = []
var _checks: int = 0


func _ready() -> void:
	await get_tree().process_frame
	var out_dir := _out_dir()
	DirAccess.make_dir_recursive_absolute(out_dir)

	var home := HOME_SCENE.instantiate()
	var lesson := LESSON_SCENE.instantiate()
	lesson.visible = false
	$Host.add_child(home)
	$Host.add_child(lesson)

	# The OS window stays fixed; the Host Control is resized to each target so
	# layout is deterministic (no WM resize animation mid-capture).
	get_window().size = Vector2i(1280, 900)
	await _frames(2)
	for size in WIDTHS:
		$Host.size = Vector2(size)
		$Host.position = Vector2.ZERO
		home.visible = true
		lesson.visible = false
		await _frames(6)
		var tag := "%dx%d" % [size.x, size.y]

		# State: loading
		home.show_loading()
		await _frames(2)
		_check(home.get_node("%StartButton").visible == false, "%s loading hides start" % tag)
		_check(home.get_node("%ExitButton").visible, "%s loading keeps exit reachable" % tag)
		await _shoot("%s-loading.png" % tag, out_dir)

		# State: home (fixture) with resume
		home.show_home({
			"nickname": "Aisyah",
			"content_mode": "fixture",
			"lesson": {"title": "Latihan Simulasi"},
			"can_resume": true,
		})
		await _frames(2)
		_check(home.get_node("%StartButton").visible, "%s home shows start" % tag)
		_check(home.get_node("%StartButton").text == "Lanjutkan", "%s resume copy" % tag)
		_check(home.get_node("%FixtureBanner").visible, "%s fixture banner visible" % tag)
		_check(home.get_node("%StartButton").size.y >= 48.0, "%s start button >= 48 high" % tag)
		_check(home.get_node("%ExitButton").size.x >= 48.0 and home.get_node("%ExitButton").size.y >= 48.0, "%s exit >= 48" % tag)
		_column_in_view(home, tag)
		await _shoot("%s-home-fixture.png" % tag, out_dir)

		# State: home (reviewed look) with start
		home.show_home({
			"nickname": "Aisyah",
			"content_mode": "reviewed_learning",
			"lesson": {"title": "Mengenal Huruf Hijaiyah"},
			"can_resume": false,
		})
		await _frames(2)
		_check(home.get_node("%FixtureBanner").visible == false, "%s reviewed hides banner" % tag)
		_check(home.get_node("%StartButton").text == "Mulai belajar", "%s start copy" % tag)
		await _shoot("%s-home-reviewed.png" % tag, out_dir)

		# State: unavailable + error
		home.show_unavailable("Materi ini belum tersedia.")
		await _frames(2)
		_check(home.get_node("%UnavailableLabel").visible and home.get_node("%StartButton").visible == false, "%s unavailable distinct" % tag)
		await _shoot("%s-unavailable.png" % tag, out_dir)
		home.show_error("Koneksi terputus. Jawabanmu belum terkonfirmasi.")
		await _frames(2)
		_check(home.get_node("%ErrorBox").visible and home.get_node("%RetryButton").visible, "%s error distinct" % tag)
		await _shoot("%s-error.png" % tag, out_dir)

		# Lesson shell
		home.visible = false
		lesson.visible = true
		lesson.show_lesson({"title": "Latihan Simulasi", "content_mode": "fixture", "round_label": ""})
		await _frames(2)
		_check(lesson.get_node("%BackButton").size.x >= 48.0 and lesson.get_node("%BackButton").size.y >= 48.0, "%s lesson back >= 48" % tag)
		await _shoot("%s-lesson.png" % tag, out_dir)

	lesson.queue_free()
	home.queue_free()

	if _failures.is_empty():
		print("[qa21] OK: %d checks passed; screenshots in %s" % [_checks, out_dir])
	else:
		for failure in _failures:
			printerr("[qa21] FAIL: " + failure)
		printerr("[qa21] %d/%d checks failed" % [_failures.size(), _checks])
	get_tree().quit(0 if _failures.is_empty() else 1)


## The primary action and exit must be inside the visible window at every
## target width (no cropped controls — QA-21 "start/exit visible").
func _column_in_view(home: Control, tag: String) -> void:
	var start: Control = home.get_node("%StartButton")
	var exit_btn: Control = home.get_node("%ExitButton")
	var view := Vector2(get_window().size)
	_check(start.get_global_rect().position.x >= 0.0 and start.get_global_rect().end.x <= view.x + 1.0,
		"%s start inside horizontal view" % tag)
	_check(exit_btn.get_global_rect().position.y >= 0.0, "%s exit below top edge" % tag)


func _shoot(file_name: String, out_dir: String) -> void:
	# Two draw cycles: the first flushes a frame painted after the state
	# change, the capture then reads a texture that certainly reflects it.
	await RenderingServer.frame_post_draw
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	# canvas_items stretch means canvas units != texture pixels; map the Host
	# rect through the viewport's final transform before cropping.
	var final: Transform2D = get_viewport().get_final_transform()
	var host: Control = $Host
	var top_left := Vector2i(final * host.global_position)
	var bottom_right := Vector2i(final * (host.global_position + host.size))
	image.get_region(Rect2i(top_left, bottom_right - top_left)).save_png(out_dir.path_join(file_name))


func _frames(n: int) -> void:
	for i in n:
		await get_tree().process_frame


func _check(condition: bool, label: String) -> void:
	_checks += 1
	if not condition:
		_failures.append(label)


func _out_dir() -> String:
	for arg in OS.get_cmdline_user_args():
		if arg.begins_with("--out="):
			return ProjectSettings.globalize_path(arg.trim_prefix("--out="))
	return ProjectSettings.globalize_path("res://../build/qa21")
