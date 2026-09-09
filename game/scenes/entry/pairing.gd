extends Control
## U02 pairing panel (native/staging only): shows the 8-character human code
## for the allowlisted parent to approve on the web, waits, and surfaces the
## outcome. The pairing_id label renders in debug builds only as a dev aid —
## the code alone is what a parent needs, and the id alone cannot redeem
## anything (the verifier never leaves native memory).

signal exit_pressed
signal retry_pressed

const COPY := preload("res://services/copy.gd")

const MAX_COLUMN_WIDTH := 480.0
const PHONE_SIDE_MARGIN := 16.0

@onready var _code_label: Label = %CodeLabel
@onready var _wait_label: Label = %WaitLabel
@onready var _pairing_id_label: Label = %PairingIdLabel
@onready var _fail_box: VBoxContainer = %FailBox
@onready var _fail_label: Label = %FailLabel
@onready var _retry_button: Button = %RetryButton
@onready var _exit_button: Button = %ExitButton
@onready var _column: VBoxContainer = %Column


func _ready() -> void:
	_exit_button.pressed.connect(func() -> void: exit_pressed.emit())
	_retry_button.pressed.connect(func() -> void: retry_pressed.emit())
	_pairing_id_label.visible = OS.is_debug_build()
	resized.connect(_apply_width_cap)
	_apply_width_cap()
	show_waiting()


## Fresh pairing created: display the code prominently.
func show_code(code: String, _expires_at: String, pairing_id: String) -> void:
	_code_label.text = code.insert(4, " ")
	_pairing_id_label.text = "pairing_id: " + pairing_id
	_fail_box.visible = false
	_wait_label.visible = true


func show_waiting() -> void:
	_fail_box.visible = false
	_wait_label.visible = true


## Terminal pairing outcome (denied / expired / lost) with a retry action.
func show_failed(message: String) -> void:
	_wait_label.visible = false
	_fail_box.visible = true
	_fail_label.text = message
	_retry_button.disabled = false


func set_retry_busy(busy: bool) -> void:
	_retry_button.disabled = busy


func _apply_width_cap() -> void:
	var available := maxf(size.x - PHONE_SIDE_MARGIN * 2.0, 0.0)
	_column.custom_minimum_size = Vector2(minf(MAX_COLUMN_WIDTH, available), 0.0)
