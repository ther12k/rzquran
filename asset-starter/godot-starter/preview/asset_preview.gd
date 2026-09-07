extends Control
## Standalone UI/sound preview only. No auth, lesson, backend, or learning content.
## Execute and inspect with the project's pinned Godot editor before adoption.

const KIDS_THEME: Theme = preload("res://assets/ui/rzq_kids_theme.tres")
const TAP: AudioStream = preload("res://assets/audio/ui/ui_tap.wav")
const CONFIRM: AudioStream = preload("res://assets/audio/ui/ui_confirm.wav")
const COMPLETE: AudioStream = preload("res://assets/audio/ui/ui_complete.wav")
var _player: AudioStreamPlayer

func _ready() -> void:
    theme = KIDS_THEME
    _player = AudioStreamPlayer.new()
    add_child(_player)
    var scroll := ScrollContainer.new()
    scroll.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
    add_child(scroll)
    var margins := MarginContainer.new()
    margins.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    for edge in ["left", "top", "right", "bottom"]:
        margins.add_theme_constant_override("margin_" + edge, 16)
    scroll.add_child(margins)
    var layout := VBoxContainer.new()
    layout.size_flags_horizontal = Control.SIZE_EXPAND_FILL
    layout.add_theme_constant_override("separation", 16)
    margins.add_child(layout)
    _label(layout, "Pratinjau aset", 28)
    _label(layout, "DEMO UI — BUKAN MATERI BELAJAR", 16)
    _label(layout, "Tema dan bunyi antarmuka. Tidak ada bacaan atau penilaian belajar.")
    var panel := PanelContainer.new()
    layout.add_child(panel)
    var content := VBoxContainer.new()
    content.add_theme_constant_override("separation", 12)
    panel.add_child(content)
    _label(content, "Contoh tampilan", 24)
    _label(content, "Tombol, kartu, dan indikator ini hanya contoh visual.")
    var progress := ProgressBar.new()
    progress.show_percentage = false
    progress.value = 50.0
    progress.custom_minimum_size = Vector2(0, 12)
    content.add_child(progress)
    _label(content, "Contoh indikator 50% — bukan data pengguna.", 16)
    var disabled := Button.new()
    disabled.text = "Contoh tombol nonaktif"
    disabled.disabled = true
    disabled.custom_minimum_size = Vector2(0, 48)
    content.add_child(disabled)
    _label(layout, "Coba bunyi antarmuka", 24)
    _label(layout, "Suara hanya diputar setelah tombol ditekan. Mulai dengan volume perangkat rendah.")
    _sound_button(layout, "Bunyi ketuk", TAP)
    _sound_button(layout, "Bunyi konfirmasi", CONFIRM)
    _sound_button(layout, "Bunyi selesai", COMPLETE)
    var stop := Button.new()
    stop.text = "Hentikan suara"
    stop.custom_minimum_size = Vector2(0, 48)
    stop.pressed.connect(_player.stop)
    layout.add_child(stop)
    _label(layout, "Font yang terlihat adalah fallback editor/engine, bukan font Arab yang disetujui.", 16)

func _label(parent: Node, value: String, font_size: int = 18) -> void:
    var label := Label.new()
    label.text = value
    label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
    label.add_theme_font_size_override("font_size", font_size)
    parent.add_child(label)

func _sound_button(parent: Node, value: String, stream: AudioStream) -> void:
    var button := Button.new()
    button.text = value
    button.custom_minimum_size = Vector2(0, 48)
    button.pressed.connect(_play_sound.bind(stream))
    parent.add_child(button)

func _play_sound(stream: AudioStream) -> void:
    _player.stop()
    _player.stream = stream
    _player.play()

func _exit_tree() -> void:
    if is_instance_valid(_player):
        _player.stop()
