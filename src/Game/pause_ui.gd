extends Control

signal game_unpaused

@onready var animation_player: AnimationPlayer = $Pause/AnimationPlayer


func _ready() -> void:
	hide()
	set_process_input(false)


func _on_game_game_paused() -> void:
	show()
	Globals.click_player.play()
	animation_player.play("PauseOn")

	await get_tree().create_timer(0.5).timeout
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		animation_player.stop()
		game_unpaused.emit()
		set_process_input(false)
		hide()
