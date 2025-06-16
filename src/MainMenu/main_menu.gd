extends Control

@onready var version_text: Label = $MarginContainer/VersionText


func _ready() -> void:
	Globals.play_menu_theme()

	# Hide the Exit button if we're playing on HTML to prevent a crash when pressed
	if OS.get_name() == "Web":
		$ButtonBox/ExitButton.hide()

	version_text.text = "v" + ProjectSettings.get_setting("application/config/version")


func _on_play_button_pressed() -> void:
	Globals.stop_menu_theme()
	Globals.go_to("res://src/Game/Game.tscn")


func _on_settings_button_pressed() -> void:
	Globals.go_to("res://src/Settings/Settings.tscn")


func _on_help_button_pressed() -> void:
	Globals.go_to("res://src/Credits/Credits.tscn")


func _on_exit_button_pressed() -> void:
	get_tree().quit()
