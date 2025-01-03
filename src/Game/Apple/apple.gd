class_name Apple extends TileMapLayer

@export var max_normal: int = 1
@export var max_golden: int = 0
@export var max_rotten: int = 0

var snake_occupied_cells: Array[Vector2i] = []

func is_apple(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) >= 0

func is_rotten(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) == 0

func spawn_apple() -> void:
	var coord: Vector2i = Vector2i(randi_range(0,Global.MAX_X), randi_range(0, Global.MAX_Y))

	if coord in snake_occupied_cells or coord in get_used_cells():
		while coord in snake_occupied_cells or coord in get_used_cells():
			coord = Vector2i(randi_range(0,Global.MAX_X), randi_range(0, Global.MAX_Y))

	set_cell(coord,1,Vector2i(0,0))

func _process(delta: float) -> void:
	print(snake_occupied_cells)

func _on_normal_timer_timeout() -> void:
	max_normal += 1


func _on_golden_timer_timeout() -> void:
	max_golden += 1


func _on_rotten_timer_timeout() -> void:
	max_rotten += 1


func _on_snake_apple_hit(coord: Vector2i) -> void:
	set_cell(coord)
	spawn_apple()
