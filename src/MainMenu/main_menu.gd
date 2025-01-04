extends Control

func _ready() -> void:
	Global.play_menu_theme()

	if OS.get_name() == "Web":
		$ButtonBox/ExitButton.hide()

func _on_play_button_pressed() -> void:
	Global.stop_menu_theme()
	Global.go_to("res://src/Game/Game.tscn")

func _on_settings_button_pressed() -> void:
	Global.go_to("res://src/Settings/Settings.tscn")

func _on_help_button_pressed() -> void:
	Global.go_to("res://src/Credits/Credits.tscn")

func _on_exit_button_pressed() -> void:
	get_tree().quit()
