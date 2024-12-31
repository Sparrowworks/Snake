extends Node2D



var _move_tween: Tween

func move(vector: Vector2i) -> void:
	if _move_tween != null: return

	_move_tween = get_tree().create_tween()
	_move_tween.tween_property(self, "position",Vector2(position.x + (vector.x * Global.MOVEMENT_SIZE),position.y + (vector.y * Global.MOVEMENT_SIZE)),0.5)
	_move_tween.tween_callback(
		func() -> void:
			_move_tween.kill()
			_move_tween = null
	)

func _process(delta: float) -> void:
	if Input.is_action_pressed("right"):
		move(Vector2i.RIGHT)

	if Input.is_action_pressed("left"):
		move(Vector2i.LEFT)

	if Input.is_action_pressed("up"):
		move(Vector2i.UP)

	if Input.is_action_pressed("down"):
		move(Vector2i.DOWN)
