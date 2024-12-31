extends Sprite2D


func _ready() -> void:
	position = Vector2(64 * randi_range(0, Global.MAX_X - 1),64 * randi_range(0, Global.MAX_Y - 1))

func _on_area_2d_area_entered(area: Area2D) -> void:
	queue_free()
