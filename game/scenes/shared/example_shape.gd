extends Control
## Single example shape (fixture: circle/square/triangle drawn as vectors;
## reviewed-learning letters render as text with explicit direction later).

@export var shape_color: Color = Color(0.184, 0.49, 0.318)
@export var tile_color: Color = Color(0.902, 0.953, 0.902)


func _draw() -> void:
	var glyph := str(get_meta("glyph", ""))
	var r := minf(size.x, size.y) * 0.24
	var center := size / 2.0
	var box := StyleBoxFlat.new()
	box.bg_color = tile_color
	box.set_corner_radius_all(int(r * 0.9))
	draw_style_box(box, Rect2(Vector2(16, 8), size - Vector2(32, 16)))
	match glyph:
		"●":
			draw_circle(center, r, shape_color)
		"■":
			draw_rect(Rect2(center - Vector2(r, r), Vector2(r * 2.0, r * 2.0)), shape_color)
		"▲":
			var pts := PackedVector2Array([
				Vector2(center.x, center.y - r * 1.15),
				Vector2(center.x + r * 1.1, center.y + r * 0.8),
				Vector2(center.x - r * 1.1, center.y + r * 0.8),
			])
			draw_colored_polygon(pts, shape_color)
