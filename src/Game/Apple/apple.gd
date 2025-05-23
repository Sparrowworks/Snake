class_name Apple extends TileMapLayer

signal score_increased(amount: int)

@onready var normal_timer: Timer = $NormalTimer
@onready var golden_timer: Timer = $GoldenTimer
@onready var rotten_timer: Timer = $RottenTimer

var snake_occupied_cells: Array[Vector2i] = []

var has_rotten: bool = false
var rotten_apple_coord: Vector2i

func is_apple(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) >= 0 # If the source_id is bigger than 0, this means that cell is not empty and is not a rotten apple

func is_rotten(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) == 0 # If the source_id is equal to 0, this means that the cell is a rotten apple

func spawn_apple(apple: int) -> void:
	# Select a random coord first
	var coord: Vector2i = Vector2i(randi_range(0, Globals.MAX_X), randi_range(0, Globals.MAX_Y))

	# If the coord is already occupied, then repeat until we select a good coordinate
	if coord in snake_occupied_cells or coord in get_used_cells():
		while coord in snake_occupied_cells or coord in get_used_cells():
			coord = Vector2i(randi_range(0, Globals.MAX_X), randi_range(0, Globals.MAX_Y))

	# 0 means rotten apple
	if apple == 0:
		rotten_apple_coord = coord # Save this coordinate, so we can later hide the apple after enough time has passed

	set_cell(coord, apple, Vector2i(0,0))

func _on_normal_timer_timeout() -> void:
	# Every time this timer finishes; we add another apple and shorten the next timer's interval
	spawn_apple(1) # 1 means normal apple
	normal_timer.wait_time = clampi(normal_timer.wait_time - 5, 10, 45)

func _on_golden_timer_timeout() -> void:
	spawn_apple(2) # 2 means golden apple

func _on_rotten_timer_timeout() -> void:
	# If we already have a rotten apple, then we hide it and pause until the next timeout
	if has_rotten:
		has_rotten = false
		set_cell(rotten_apple_coord) # Clear the cell
	else:
		# If we don't, then we spawn the rotten apple and let it be for 15s
		has_rotten = true
		spawn_apple(0)
		if rotten_timer.wait_time != 15:
			rotten_timer.wait_time = 15
			rotten_timer.start()

func _on_snake_apple_hit(coord: Vector2i) -> void:
	if get_cell_source_id(coord) == 1:
		score_increased.emit(1)
		spawn_apple(1)
		$PickupNormal.play()
	elif get_cell_source_id(coord) == 2:
		# If we collect a golden apple, we gain more score and the wait time for the next one is shortened
		score_increased.emit(3)
		golden_timer.wait_time = clampi(golden_timer.wait_time - 1, 10, 20)
		golden_timer.start()
		$PickupGolden.play()

	set_cell(coord) # Clear the cell

func _on_snake_game_over() -> void:
	# Stop all timers
	normal_timer.stop()
	golden_timer.stop()
	rotten_timer.stop()

	# Hide all apples on game over.
	var apple_tween: Tween = get_tree().create_tween()
	apple_tween.tween_property(self, "modulate:a", 0.0, 1.0)
	apple_tween.tween_callback(apple_tween.kill)
