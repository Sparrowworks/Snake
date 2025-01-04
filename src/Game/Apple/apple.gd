class_name Apple extends TileMapLayer

signal score_increased(amount: int)

@onready var normal_timer: Timer = $NormalTimer
@onready var golden_timer: Timer = $GoldenTimer
@onready var rotten_timer: Timer = $RottenTimer

var snake_occupied_cells: Array[Vector2i] = []

var has_rotten: bool = false
var rotten_apple_coord: Vector2i

func is_apple(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) >= 0

func is_rotten(cell: Vector2i) -> bool:
	return get_cell_source_id(cell) == 0

func spawn_apple(apple: int) -> void:
	var coord: Vector2i = Vector2i(randi_range(0,Global.MAX_X), randi_range(0, Global.MAX_Y))

	if coord in snake_occupied_cells or coord in get_used_cells():
		while coord in snake_occupied_cells or coord in get_used_cells():
			coord = Vector2i(randi_range(0,Global.MAX_X), randi_range(0, Global.MAX_Y))

	if apple == 0:
		rotten_apple_coord = coord

	set_cell(coord,apple,Vector2i(0,0))

func _on_normal_timer_timeout() -> void:
	spawn_apple(1)
	normal_timer.wait_time = clampi(normal_timer.wait_time - 5, 10, 45)

func _on_golden_timer_timeout() -> void:
	spawn_apple(2)

func _on_rotten_timer_timeout() -> void:
	if has_rotten:
		has_rotten = false
		set_cell(rotten_apple_coord)
	else:
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
		score_increased.emit(3)
		golden_timer.wait_time = clampi(golden_timer.wait_time - 2,10,20)
		golden_timer.start()
		$PickupGolden.play()

	set_cell(coord)


func _on_snake_game_over() -> void:
	normal_timer.stop()
	golden_timer.stop()
	rotten_timer.stop()

	var apple_tween: Tween = get_tree().create_tween()
	apple_tween.tween_property(self,"modulate:a",0.0,1.0)
	apple_tween.tween_callback(apple_tween.kill)
