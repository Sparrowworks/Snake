class_name Snake extends TileMapLayer

@onready var move_timer: Timer = $MoveTimer

var current_occupied: Array[Vector2i] = []
var current_dir: Vector2i = Vector2i.RIGHT

func _ready() -> void:
	current_occupied.append(get_used_cells()[0])

func _process(delta: float) -> void:
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

func _move_single(direction: Vector2i) -> void:
	var head: Vector2i = current_occupied[0]
	var new_head: Vector2i = Vector2i(head.x + direction.x, head.y + direction.y)

	if check_if_borders(new_head):
		return

	set_cell(new_head,2,Vector2i(0,0))
	set_cell(head)
	current_occupied[0] = new_head

func move(direction: Vector2i) -> void:
	if current_occupied.size() == 1:
		_move_single(direction)
		return

func check_if_borders(coords: Vector2i) -> bool:
	return coords.x > 19 or coords.y > 19

func change_dir_manual(new_dir: Vector2i) -> void:
	move_timer.stop()
	current_dir = new_dir
	move(current_dir)
	move_timer.start()
