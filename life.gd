extends Node2D

const GRID_SIZE = 16
const CELL_COLOR = Color(256/256.0, 256/256.0, 256/256.0)

func _draw():
	var screen_size = get_viewport_rect().size
	draw_rect(Rect2(Vector2(0, 0), Vector2(16, 16)), CELL_COLOR, true)
