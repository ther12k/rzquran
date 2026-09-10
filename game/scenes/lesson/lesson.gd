extends Control
## Lesson flow (GDM-012/014/015): three example units then three question
## rounds, driven entirely by server state (godot-structure.md).
##   EXAMPLES -> QUESTION -> SUBMITTING -> FEEDBACK -> QUESTION | FINISHING -> RESULT
## The scene is display-only; the root state machine performs every transport
## call and passes typed state in. Shapes are DRAWN as vectors (fixture is
## Arabic-free and must not depend on glyph coverage); reviewed-learning mode
## renders unit text LTR/RTL-explicitly when it arrives (GDM-027 gate).

signal next_requested
signal option_selected(option_id: String)
signal check_requested
signal continue_after_feedback_requested
signal finish_requested
signal retry_lesson_requested
signal home_requested

const COPY := preload("res://services/copy.gd")

const MAX_COLUMN_WIDTH := 480.0
const PHONE_SIDE_MARGIN := 16.0
const TOTAL_ROUNDS := 3

@onready var _title: Label = %LessonTitle
@onready var _banner: PanelContainer = %FixtureBanner
@onready var _progress: Label = %Progress
@onready var _progressbar: ProgressBar = %Progressbar
@onready var _back_button: Button = %BackButton
@onready var _content: VBoxContainer = %ContentBox

# Example unit nodes
@onready var _example_card: PanelContainer = %ExampleCard
@onready var _example_shapes: Control = %ExampleShapes
@onready var _example_label: Label = %ExampleLabel
@onready var _example_instruction: Label = %ExampleInstruction
@onready var _example_note: Label = %AudioNote
@onready var _example_next: Button = %ExampleNext

# Question unit nodes
@onready var _question_card: PanelContainer = %QuestionCard
@onready var _question_prompt: Label = %QuestionPrompt
@onready var _options_box: VBoxContainer = %OptionsBox
@onready var _check_button: Button = %CheckButton

# Feedback nodes
@onready var _feedback_box: PanelContainer = %FeedbackBox
@onready var _feedback_label: Label = %FeedbackLabel
@onready var _feedback_continue: Button = %FeedbackContinue

# Result nodes
@onready var _result_card: PanelContainer = %ResultCard
@onready var _result_counts: Label = %ResultCounts
@onready var _result_accuracy: Label = %ResultAccuracy
@onready var _result_mascot: TextureRect = %ResultMascot
@onready var _retry_button: Button = %RetryButton
@onready var _home_button: Button = %HomeButton

@onready var _column: VBoxContainer = %Column

var _selected_option: String = ""
var _option_buttons: Dictionary = {}


func _ready() -> void:
	_back_button.pressed.connect(func() -> void: home_requested.emit())
	_example_next.pressed.connect(func() -> void: next_requested.emit())
	_check_button.pressed.connect(func() -> void: check_requested.emit())
	_feedback_continue.pressed.connect(func() -> void: continue_after_feedback_requested.emit())
	_retry_button.pressed.connect(func() -> void: retry_lesson_requested.emit())
	_home_button.pressed.connect(func() -> void: home_requested.emit())
	resized.connect(_apply_width_cap)
	_apply_width_cap()


## Common chrome for every step: title, fixture badge, step counter, back.
func show_header(ctx: Dictionary) -> void:
	var fixture: bool = str(ctx.get("content_mode", "")) == "fixture"
	_banner.visible = fixture
	_title.text = COPY.FIXTURE_TITLE if fixture else str(ctx.get("title", ""))
	var step := int(ctx.get("step", 0))
	var total := int(ctx.get("total", 0))
	_progress.text = COPY.QUESTION_PROGRESS % [step, total] if step > 0 else ""
	_progressbar.value = float(ctx.get("percent", 0))


## U05 example unit: one shape glyph, its name, honest no-audio note.
func show_example(ctx: Dictionary) -> void:
	_hide_all_steps()
	_example_card.visible = true
	_example_shapes.set_meta("glyph", str(ctx.get("glyph", "")))
	_example_shapes.queue_redraw()
	_example_label.text = str(ctx.get("label", ""))
	_example_instruction.text = str(ctx.get("instruction", ""))
	_example_next.text = COPY.ACTION_NEXT


## U06 question round: prompt + large selectable options (no drag).
func show_question(ctx: Dictionary) -> void:
	_hide_all_steps()
	_selected_option = ""
	_option_buttons.clear()
	_question_card.visible = true
	_question_prompt.text = str(ctx.get("prompt", ""))
	for child in _options_box.get_children():
		child.queue_free()
	var options: Array = ctx.get("options", [])
	for option in options:
		if typeof(option) != TYPE_DICTIONARY:
			continue
		var option_id := str(option.get("option_id", ""))
		var button := Button.new()
		button.text = "   " + str(option.get("label", ""))
		button.custom_minimum_size = Vector2(0, 56)
		button.theme_type_variation = "GhostButton"
		button.pressed.connect(func() -> void: _on_option(option_id, button))
		_options_box.add_child(button)
		_option_buttons[option_id] = button
	_check_button.disabled = true
	_check_button.text = COPY.ACTION_CHECK


func set_submitting(busy: bool) -> void:
	_check_button.disabled = busy or _selected_option.is_empty()
	for option_id in _option_buttons:
		(_option_buttons[option_id] as Button).disabled = busy


## U07 feedback: text + non-color state (check/cross prefix), replay-free.
func show_feedback(ctx: Dictionary) -> void:
	_hide_all_steps()
	_feedback_box.visible = true
	var correct: bool = bool(ctx.get("correct", false))
	var first: bool = bool(ctx.get("first", true))
	_feedback_label.text = ("✔ " + COPY.FEEDBACK_CORRECT if correct else "✘ " + COPY.FEEDBACK_RETRY) + ("" if first else COPY.FEEDBACK_NOT_FIRST)
	_feedback_continue.text = COPY.ACTION_NEXT
	_feedback_continue.grab_focus()


## U08 result: server-confirmed counts only; practice language, no mastery.
func show_result(ctx: Dictionary) -> void:
	_hide_all_steps()
	_result_card.visible = true
	_result_counts.text = COPY.RESULT_BODY % int(ctx.get("count", 0))
	_result_accuracy.text = COPY.RESULT_ACCURACY % [int(ctx.get("correct", 0)), int(ctx.get("total", 0))]


func _on_option(option_id: String, button: Button) -> void:
	_selected_option = option_id
	# Non-color selection state: selected option shows the check prefix.
	for other_id in _option_buttons:
		var b: Button = _option_buttons[other_id]
		b.text = ("● " if other_id == option_id else "   ") + b.text.trim_prefix("● ").trim_prefix("✘ ").trim_prefix("   ")
	_check_button.disabled = false
	option_selected.emit(option_id)


func selected_option() -> String:
	return _selected_option


func _hide_all_steps() -> void:
	_example_card.visible = false
	_question_card.visible = false
	_feedback_box.visible = false
	_result_card.visible = false


func _apply_width_cap() -> void:
	var available := maxf(size.x - PHONE_SIDE_MARGIN * 2.0, 0.0)
	_column.custom_minimum_size = Vector2(minf(MAX_COLUMN_WIDTH, available), 0.0)
