extends Control


func _on_play_button_pressed() -> void:
	go_to("res://src/Game/Game.tscn")


func _on_hi_button_pressed() -> void:
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	go_to("res://src/Settings/Settings.tscn")


func _on_credits_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()

func go_to(scene: String) -> void:
	var transition: Node = Composer.setup_load_screen(Global.loading_transition)
	await transition.finished_fade_in
	Composer.load_scene(scene)
