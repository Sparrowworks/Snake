class_name Snake extends TileMapLayer

signal body_hit
signal apple_hit(coord: Vector2i)
signal rotten_hit

signal game_over

@export var apple_tilemap: Apple

@onready var move_timer: Timer = $MoveTimer

const MAX_SNAKE_WAIT_TIME: float = 0.85
const MIN_SNAKE_WAIT_TIME: float = 0.15
const FRAME_LIMIT: int = 30

var current_occupied: Array[Vector2i] = []
var current_dir: Vector2i = Vector2i.UP

var frame: int = 0


func _ready() -> void:
	# Add the head and the tail to the occupied cells array
	current_occupied.append_array(get_used_cells())

	# Tell the apple scene where not to spawn apples
	apple_tilemap.snake_occupied_cells = current_occupied
	apple_tilemap.spawn_apple(1)


func _process(_delta: float) -> void:
	if frame < FRAME_LIMIT:
		# Move the snake when key has been tapped
		if Input.is_action_just_pressed("down"):
			change_dir_manual(Vector2i.DOWN)
		elif Input.is_action_just_pressed("up"):
			change_dir_manual(Vector2i.UP)
		elif Input.is_action_just_pressed("left"):
			change_dir_manual(Vector2i.LEFT)
		elif Input.is_action_just_pressed("right"):
			change_dir_manual(Vector2i.RIGHT)

	frame += 1
	if frame % FRAME_LIMIT != 0:  # A delay for moving the snake when holding down the key
		return

	# Move the snake when holding down the key
	frame = 0
	if Input.is_action_pressed("down"):
		change_dir_manual(Vector2i.DOWN)
	elif Input.is_action_pressed("up"):
		change_dir_manual(Vector2i.UP)
	elif Input.is_action_pressed("left"):
		change_dir_manual(Vector2i.LEFT)
	elif Input.is_action_pressed("right"):
		change_dir_manual(Vector2i.RIGHT)


func _on_move_timer_timeout() -> void:
	# When the move timer finishes, we move the snake automatically
	move(current_dir)


func move(direction: Vector2i) -> void:
	var head: Vector2i = current_occupied[0]  # Get current head position
	var new_head: Vector2i = Vector2i(head.x + direction.x, head.y + direction.y)  # Move the old head

	# If we go beyond the boundaries, we move to the opposite side of the map
	if new_head.x > 19:
		new_head.x = 0
	elif new_head.x < 0:
		new_head.x = 19

	if new_head.y > 19:
		new_head.y = 0
	elif new_head.y < 0:
		new_head.y = 19

	# Check if we didn't hit ourselves
	if check_if_body(new_head):
		body_hit.emit()
		return

	# Check if we didn't hit an apple
	if apple_tilemap.is_apple(new_head):
		# If we hit a rotten apple, the game is over
		if apple_tilemap.is_rotten(new_head):
			apple_hit.emit(new_head)
			rotten_hit.emit()
			return

		apple_hit.emit(new_head)

		add_body(new_head)  # Add a new body part when we hit an apple
		return

	# Add a new head (the removal of old head and rotation of the new one will be done by draw_snake)
	set_cell(new_head, 1, Vector2i(0, 0))
	current_occupied.insert(0, new_head)
	set_cell(current_occupied.pop_back())

	draw_snake()


func draw_snake() -> void:
	for x in range(0, current_occupied.size()):
		var coord: Vector2i = current_occupied[x]
		if x == 0:  # If it's head, rotate it accordingly
			match current_dir:
				Vector2i.UP:
					set_cell(coord, 1, Vector2i(0, 0), 0)
				Vector2i.DOWN:
					set_cell(coord, 1, Vector2i(0, 0), 1)
				Vector2i.LEFT:
					set_cell(coord, 1, Vector2i(0, 0), 2)
				Vector2i.RIGHT:
					set_cell(coord, 1, Vector2i(0, 0), 3)
		elif x == current_occupied.size() - 1:
			# The last tile is a tail, so we must also rotate it correctly
			var prev_dir: Vector2i = coord - current_occupied[x - 1]  # Get the direction of the body part we're bordering with
			match prev_dir:
				Vector2i.UP:
					set_cell(coord, 2, Vector2i(0, 0), 1)
				Vector2i.DOWN:
					set_cell(coord, 2, Vector2i(0, 0), 0)
				Vector2i.LEFT:
					set_cell(coord, 2, Vector2i(0, 0), 3)
				Vector2i.RIGHT:
					set_cell(coord, 2, Vector2i(0, 0), 2)
		else:
			set_cell(coord, 0, Vector2i(0, 0))  # The body doesn't need any corrections


func check_if_body(coord: Vector2i) -> bool:
	return coord in current_occupied  # Check if a cell is part of the snake


func change_dir_manual(new_dir: Vector2i) -> void:
	if current_occupied.size() > 1:
		# Prevent direct movements in the opposite directions
		if (
			(new_dir == Vector2i.RIGHT and current_dir == Vector2i.LEFT)
			or (new_dir == Vector2i.LEFT and current_dir == Vector2i.RIGHT)
			or (new_dir == Vector2i.UP and current_dir == Vector2i.DOWN)
			or (new_dir == Vector2i.DOWN and current_dir == Vector2i.UP)
		):
			return

	# Reset the frame counter and the move timer when we moved manually
	frame = 0
	move_timer.stop()

	# Update the direction and move the snake
	current_dir = new_dir
	move(current_dir)
	move_timer.start()


func add_body(coord: Vector2i) -> void:
	# Add a new body part to the snake
	current_occupied.insert(0, coord)
	set_cell(coord, 0, Vector2i(0, 0))
	draw_snake()  # Redraw the whole body


func game_end() -> void:
	# Stop the snake from moving
	process_mode = PROCESS_MODE_DISABLED
	move_timer.stop()
	$DifficultyTimer.stop()
	game_over.emit()


func _on_difficulty_timer_timeout() -> void:
	# Each time this timer finishes, we shorten the wait time for snake to move on his own, making the game more difficult
	move_timer.wait_time = clampf(
		move_timer.wait_time - 0.05, MIN_SNAKE_WAIT_TIME, MAX_SNAKE_WAIT_TIME
	)
	move_timer.start()
