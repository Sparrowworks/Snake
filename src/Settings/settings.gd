extends Control

@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider

@onready var sfx_label: Label = %SfxLabel
@onready var sfx_slider: HSlider = %SfxSlider


func _ready() -> void:
	_update_settings()


func _update_settings() -> void:
	# Displays user's changes to music and SFX volumes using slider values
	music_label.text = "Music Volume: " + str(int(Globals.music_volume))
	sfx_label.text = "SFX Volume: " + str(int(Globals.sfx_volume))

	# Set proper text and slider values
	music_label.text = "Music Volume: " + str(int(Globals.music_volume))
	sfx_label.text = "SFX Volume: " + str(int(Globals.sfx_volume))

	music_slider.value = Globals.music_volume
	sfx_slider.value = Globals.sfx_volume

	# Update the volume on both buses
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"), linear_to_db(Globals.music_volume / 100)
	)
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("SFX"), linear_to_db(Globals.sfx_volume / 100)
	)


func _on_back_button_pressed() -> void:
	Globals.go_to("res://src/MainMenu/MainMenu.tscn")


func _on_reset_button_pressed() -> void:
	Globals.music_volume = 100
	Globals.sfx_volume = 100

	_update_settings()


func _on_music_slider_value_changed(value: float) -> void:
	Globals.music_volume = value
	_update_settings()


func _on_sfx_slider_value_changed(value: float) -> void:
	Globals.sfx_volume = value
	_update_settings()
