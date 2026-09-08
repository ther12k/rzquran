extends Control
## Lesson shell (GDM-011 foundation for GDM-012/013/014/015): header with the
## always-reachable back control, fixture badge and the content area where the
## three examples and question rounds render. The content area is INTENTIONALLY
## empty in this task — a debug-build note marks it; release builds show a clean
## non-misleading surface until the lesson flow lands.

signal exit_to_home

const COPY := preload("res://services/copy.gd")

const MAX_COLUMN_WIDTH := 480.0
const PHONE_SIDE_MARGIN := 16.0

@onready var _title: Label = %LessonTitle
@onready var _banner: PanelContainer = %FixtureBanner
@onready var _progress: Label = %Progress
@onready var _back_button: Button = %BackButton
@onready var _debug_note: Label = %DebugNote
@onready var _column: VBoxContainer = %Column


func _ready() -> void:
	_back_button.pressed.connect(func() -> void: exit_to_home.emit())
	resized.connect(_apply_width_cap)
	_debug_note.visible = OS.is_debug_build()
	_apply_width_cap()


## `ctx`: {title: String, content_mode: String, round_label: String}.
func show_lesson(ctx: Dictionary) -> void:
	var fixture: bool = bool(ctx.get("content_mode", "") == "fixture")
	_banner.visible = fixture
	_title.text = COPY.FIXTURE_TITLE if fixture else str(ctx.get("title", ""))
	_progress.text = str(ctx.get("round_label", ""))


func _apply_width_cap() -> void:
	var available := maxf(size.x - PHONE_SIDE_MARGIN * 2.0, 0.0)
	_column.custom_minimum_size = Vector2(minf(MAX_COLUMN_WIDTH, available), 0.0)
