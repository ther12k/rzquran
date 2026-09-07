extends Node
## Build identity shown at runtime during development (GDM-002 acceptance).
## The build script writes res://build/build_id.txt right before exporting;
## running from the editor falls back to the unversioned marker.

var build_id: String = "dev-unversioned"


func _ready() -> void:
	var f := FileAccess.open("res://build/build_id.txt", FileAccess.READ)
	if f != null:
		var line := f.get_line().strip_edges()
		if not line.is_empty():
			build_id = line
