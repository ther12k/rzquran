extends Node
## UI feedback sounds only (asset-starter adoption, GDA-001 scope).
## Rules from asset-starter/docs/godot-integration.md:
## - cues are optional and NEVER autoplay; played only on explicit actions
## - suppressed while instructional audio is playing (GDM-013 owns that path)
## - stop_all() on exit, profile switch, terminal session state, recall
## These are interface tones, not pronunciation or learning content.

const TAP: AudioStream = preload("res://assets/audio/ui/ui_tap.wav")
const CONFIRM: AudioStream = preload("res://assets/audio/ui/ui_confirm.wav")
const COMPLETE: AudioStream = preload("res://assets/audio/ui/ui_complete.wav")

var _player: AudioStreamPlayer
## Set by the lesson audio path (GDM-013) while instructional audio plays.
var instructional_audio_active: bool = false


func _ready() -> void:
	_player = AudioStreamPlayer.new()
	_player.bus = "Master"
	add_child(_player)


func play_tap() -> void:
	_play(TAP)


func play_confirm() -> void:
	_play(CONFIRM)


func play_complete() -> void:
	_play(COMPLETE)


func stop_all() -> void:
	if is_instance_valid(_player):
		_player.stop()


func _play(stream: AudioStream) -> void:
	if instructional_audio_active:
		return
	if not is_instance_valid(_player):
		return
	_player.stop()
	_player.stream = stream
	_player.play()


func _exit_tree() -> void:
	stop_all()
