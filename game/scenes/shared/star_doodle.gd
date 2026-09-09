extends Control
## Small decorative star drawn as a vector polygon (mockup language has
## scattered stars; we draw them rather than crop assets or rely on glyphs).

@export var star_color: Color = Color(1.0, 0.788, 0.235)
@export var points_count: int = 5
@export var inner_ratio: float = 0.45


func _draw() -> void:
	var center := size / 2.0
	var outer := minf(size.x, size.y) / 2.0
	var inner := outer * inner_ratio
	var pts := PackedVector2Array()
	for i in points_count * 2:
		var angle := -PI / 2.0 + TAU * float(i) / float(points_count * 2)
		var radius := outer if i % 2 == 0 else inner
		pts.append(center + Vector2(cos(angle), sin(angle)) * radius)
	draw_colored_polygon(pts, star_color)
