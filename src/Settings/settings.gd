extends Control


func _on_back_button_pressed() -> void:
	var transition: Node = Composer.setup_load_screen(Global.loading_transition)
	await transition.finished_fade_in
	Composer.load_scene("res://src/MainMenu/MainMenu.tscn")
