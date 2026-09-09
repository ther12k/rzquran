extends Control
## U04 Child home — one lesson card, fixture badge, one clear start/resume
## action, exit control. Display-only: the root state machine (scenes/entry)
## drives it and connects signals. The content column reflows between 360–430
## phone widths and is width-capped/centered on tablet/desktop; the column
## scrolls in landscape instead of being cropped (GDM-011/QA-21).

signal start_pressed
signal exit_pressed
signal retry_pressed

const COPY := preload("res://services/copy.gd")

## Widest content column; narrower viewports shrink it with the 16 margins.
const MAX_COLUMN_WIDTH := 480.0
const PHONE_SIDE_MARGIN := 16.0
const LESSON_TEASER := "Dengarkan contoh, lalu pilih jawabannya."

@onready var _greeting: Label = %Greeting
@onready var _subtitle: Label = %Subtitle
@onready var _banner: PanelContainer = %FixtureBanner
@onready var _card: PanelContainer = %LessonCard
@onready var _card_title: Label = %CardTitle
@onready var _card_desc: Label = %CardDesc
@onready var _start_button: Button = %StartButton
@onready var _exit_button: Button = %ExitButton
@onready var _loading: Label = %LoadingLabel
@onready var _unavailable: Label = %UnavailableLabel
@onready var _error_box: VBoxContainer = %ErrorBox
@onready var _error_label: Label = %ErrorLabel
@onready var _retry_button: Button = %RetryButton
@onready var _column: VBoxContainer = %Column

var _fixture_on: bool = false


func _ready() -> void:
	_start_button.pressed.connect(func() -> void: start_pressed.emit())
	_exit_button.pressed.connect(func() -> void: exit_pressed.emit())
	_retry_button.pressed.connect(func() -> void: retry_pressed.emit())
	resized.connect(_apply_width_cap)
	# Anchored controls may already be sized before _ready runs, in which
	# case resized never fires again — apply the cap once explicitly.
	_apply_width_cap()
	show_loading()


## Distinct state: loading (nothing actionable yet, no fake percent).
func show_loading() -> void:
	_set_home_visible(false)
	_loading.visible = true
	_loading.text = COPY.LOAD_WAIT


## Distinct state: terminal unavailability (no lesson, version mismatch,
## recalled content). Never shown together with the start card.
func show_unavailable(message: String) -> void:
	_set_home_visible(false)
	_unavailable.visible = true
	_unavailable.text = message


## Distinct state: recoverable failure with a retry action.
func show_error(message: String) -> void:
	_set_home_visible(false)
	_error_box.visible = true
	_error_label.text = message


## HOME proper: greeting, subtitle, fixture badge and exactly one primary
## start/resume action. `can_resume` comes from the server-side session.
func show_home(ctx: Dictionary) -> void:
	_fixture_on = bool(ctx.get("content_mode", "") == "fixture")
	_set_home_visible(true)
	var nickname := str(ctx.get("nickname", ""))
	_greeting.text = COPY.HOME_GREETING % nickname if nickname != "" else "Halo!"
	_banner.visible = _fixture_on
	var lesson: Dictionary = ctx.get("lesson", {}) if typeof(ctx.get("lesson")) == TYPE_DICTIONARY else {}
	_card_title.text = COPY.FIXTURE_TITLE if _fixture_on else str(lesson.get("title", ""))
	_card_desc.text = LESSON_TEASER
	_start_button.text = COPY.ACTION_RESUME if bool(ctx.get("can_resume", false)) else COPY.ACTION_START
	_start_button.disabled = false


## STARTING state: the single action disables while the request is in flight.
func set_busy(busy: bool) -> void:
	_start_button.disabled = busy
	_retry_button.disabled = busy


func _set_home_visible(home_visible: bool) -> void:
	_loading.visible = false
	_unavailable.visible = false
	_error_box.visible = false
	_greeting.visible = home_visible
	_subtitle.visible = home_visible
	_banner.visible = home_visible and _fixture_on
	_card.visible = home_visible
	_start_button.visible = home_visible
	# Exit stays reachable in every state (interaction rules: never obstruct exit).
	_exit_button.visible = true


## Width cap: 360–430 phones use the full column (16-unit margins live in the
## scene); tablet/desktop keeps a comfortable centered activity area instead
## of stretching the phone layout across the screen.
func _apply_width_cap() -> void:
	var available := maxf(size.x - PHONE_SIDE_MARGIN * 2.0, 0.0)
	_column.custom_minimum_size = Vector2(minf(MAX_COLUMN_WIDTH, available), 0.0)
