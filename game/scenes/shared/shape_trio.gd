extends Control
## Fixture illustration: three pastel tiles with a circle, square and
## triangle drawn as vector primitives (custom _draw). Fixture symbols must
## not depend on font glyph coverage, and mockup art must never be flattened
## into screenshots — so the shapes are drawn, not typed or rasterised.

const TILE_COLORS := [
	Color(0.902, 0.953, 0.902), # green
	Color(1.0, 0.953, 0.804), # yellow
	Color(0.937, 0.914, 0.98), # purple
]
const SHAPE_COLORS := [
	Color(0.184, 0.49, 0.318), # green
	Color(0.957, 0.62, 0.243), # amber
	Color(0.545, 0.361, 0.965), # purple
]


func _draw() -> void:
	var tile := minf(size.x / 3.0, size.y)
	var gap := (size.x - tile * 3.0) / 2.0 if size.x > tile * 3.0 else 8.0
	var total_w := tile * 3.0 + gap * 2.0
	var origin_x := (size.x - total_w) / 2.0
	var origin_y := (size.y - tile) / 2.0
	for i in 3:
		var top_left := Vector2(origin_x + i * (tile + gap), origin_y)
		var rect := Rect2(top_left, Vector2(tile, tile))
		draw_style_box(_tile_box(i), rect)
		_draw_shape(i, rect.get_center(), tile * 0.26)


func _tile_box(i: int) -> StyleBoxFlat:
	var box := StyleBoxFlat.new()
	box.bg_color = TILE_COLORS[i]
	box.set_corner_radius_all(int(tile_radius()))
	return box


func tile_radius() -> float:
	return minf(size.x, size.y) * 0.22


func _draw_shape(i: int, center: Vector2, r: float) -> void:
	var col := SHAPE_COLORS[i]
	match i:
		0:
			draw_circle(center, r, col)
		1:
			draw_rect(Rect2(center - Vector2(r, r), Vector2(r * 2.0, r * 2.0)), col)
		2:
			var points := PackedVector2Array([
				Vector2(center.x, center.y - r * 1.15),
				Vector2(center.x + r * 1.1, center.y + r * 0.8),
				Vector2(center.x - r * 1.1, center.y + r * 0.8),
			])
			draw_colored_polygon(points, col)
