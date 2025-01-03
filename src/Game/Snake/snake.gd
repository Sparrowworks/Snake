class_name Snake extends TileMapLayer

signal borders_hit()
signal body_hit()

signal apple_hit(coord: Vector2i)
signal rotten_hit()

@export var apple_tilemap: Apple

@onready var move_timer: Timer = $MoveTimer

var current_occupied: Array[Vector2i] = []
var current_dir: Vector2i = Vector2i.RIGHT

func _ready() -> void:
	current_occupied.append(get_used_cells()[0])
	apple_tilemap.snake_occupied_cells = current_occupied
	apple_tilemap.spawn_apple()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("down"):
		change_dir_manual(Vector2i.DOWN)
	elif Input.is_action_just_pressed("up"):
		change_dir_manual(Vector2i.UP)

	if Input.is_action_just_pressed("left"):
		change_dir_manual(Vector2i.LEFT)
	elif Input.is_action_just_pressed("right"):
		change_dir_manual(Vector2i.RIGHT)

func _on_move_timer_timeout() -> void:
	move(current_dir)

func move(direction: Vector2i) -> void:
	var head: Vector2i = current_occupied[0]
	var new_head: Vector2i = Vector2i(head.x + direction.x, head.y + direction.y)

	if check_if_borders(new_head):
		borders_hit.emit()
		return

	if apple_tilemap.is_apple(new_head):
		if apple_tilemap.is_rotten(new_head):
			rotten_hit.emit()
			return

		apple_hit.emit(new_head)
		add_body(new_head)
		return

	set_cell(new_head,0,Vector2i(0,0))
	current_occupied.insert(0,new_head)
	set_cell(current_occupied.pop_back())

func check_if_borders(coords: Vector2i) -> bool:
	return coords.x > 19 or coords.y > 19

func change_dir_manual(new_dir: Vector2i) -> void:
	move_timer.stop()
	current_dir = new_dir
	move(current_dir)
	move_timer.start()

func add_body(coord: Vector2i) -> void:
	current_occupied.insert(0,coord)
	set_cell(coord, 0, Vector2i(0,0))
