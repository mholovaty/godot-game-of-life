extends Node2D

const GRID_SIZE = 16
const GRID_COLOR = Color(100/256.0, 100/256.0, 100/256.0)

func _draw():
	var screen_size = get_viewport_rect().size
	for x in range(0, screen_size.x, GRID_SIZE):
		draw_line(Vector2(x, 0), Vector2(x, screen_size.y), GRID_COLOR)
	for y in range(0, screen_size.y, GRID_SIZE):
		draw_line(Vector2(0, y), Vector2(screen_size.x, y), GRID_COLOR)
