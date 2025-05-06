extends Node2D

const GRID_SIZE = 8  # FIXME import the variable from grid.gd
const CELL_COLOR = Color(256/256.0, 256/256.0, 256/256.0)

var state = {
	# Gosper Glider Gun

	# TODO Add cell type
	Vector2(2, 2): true,
	Vector2(2, 3): true,
	Vector2(3, 2): true,
	Vector2(3, 3): true,
	
	Vector2(12, 2): true,
	Vector2(12, 3): true,
	Vector2(12, 4): true,
	Vector2(13, 1): true,
	Vector2(13, 5): true,
	Vector2(14, 0): true,
	Vector2(14, 6): true,
	Vector2(15, 0): true,
	Vector2(15, 6): true,
	Vector2(16, 3): true,
	Vector2(17, 1): true,
	Vector2(17, 5): true,
	Vector2(18, 2): true,
	Vector2(18, 3): true,
	Vector2(18, 4): true,
	Vector2(19, 3): true,
	
	Vector2(22, 0): true,
	Vector2(22, 1): true,
	Vector2(22, 2): true,
	Vector2(23, 0): true,
	Vector2(23, 1): true,
	Vector2(23, 2): true,
	Vector2(24, 3): true,
	Vector2(24, -1): true,
	Vector2(26, 3): true,
	Vector2(26, -1): true,
	Vector2(26, -2): true,
	Vector2(26, 4): true,

	Vector2(36, 0): true,
	Vector2(37, 0): true,
	Vector2(36, 1): true,
	Vector2(37, 1): true,
}

var timer


func get_neighbors(st, cell: Vector2):
	var n1 = Vector2(cell.x - 1, cell.y - 1)
	var n2 = Vector2(cell.x - 1, cell.y + 0)
	var n3 = Vector2(cell.x - 1, cell.y + 1)
	var n4 = Vector2(cell.x + 0, cell.y - 1)
	var n5 = Vector2(cell.x + 0, cell.y + 1)
	var n6 = Vector2(cell.x + 1, cell.y - 1)
	var n7 = Vector2(cell.x + 1, cell.y + 0)
	var n8 = Vector2(cell.x + 1, cell.y + 1)

	return {
		n1: n1 in st,
		n2: n2 in st,
		n3: n3 in st,
		n4: n4 in st,
		n5: n5 in st,
		n6: n6 in st,
		n7: n7 in st,
		n8: n8 in st,
	}


func count_alive(cells):
	var count = 0
	for k in cells:
		if cells[k]:
			count += 1
	return count


func becomes_dead(st, cell: Vector2):
	var neighbors = get_neighbors(st, cell)
	var count = count_alive(neighbors)
	if count < 2:
		return true
	if count > 3:
		return true
	return false


func becomes_alive(st, cell: Vector2):
	var neighbors = get_neighbors(st, cell)
	var count = count_alive(neighbors)
	if count == 3:
		return true
	return false


func _advance():
	var old_state = state.duplicate()

	state.clear()
	for cell in old_state:
		var is_alive = not becomes_dead(old_state, cell)
		if is_alive:
			state[cell] = is_alive
		var neighbors = get_neighbors(old_state, cell)
		for neighbor in neighbors:
			if neighbor in state:
				continue
			if neighbors[neighbor]:
				if not becomes_dead(old_state, neighbor):
					state[neighbor] = true
			else:
				if becomes_alive(old_state, neighbor):
					state[neighbor] = true

func _ready():
	timer = Timer.new()
	# TODO Parameterize speed
	timer.wait_time = 0.2
	timer.one_shot = false
	add_child(timer)
	timer.timeout.connect(_on_timer_timeout)
	
	timer.start()


func _on_timer_timeout():
	_advance()
	queue_redraw()  # Request a redraw


func _draw_cell(cell: Vector2):
	# TODO Parameterize initial position
	var x = (cell.x + 5) * GRID_SIZE
	var y = (cell.y + 5) * GRID_SIZE
	draw_rect(
		Rect2(
			Vector2(x, y),
			Vector2(GRID_SIZE, GRID_SIZE)),
		CELL_COLOR,
		true)

func _draw():
	for cell in state:
		_draw_cell(cell)
