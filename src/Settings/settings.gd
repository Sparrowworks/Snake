extends Control

@onready var music_label: Label = %MusicLabel
@onready var music_slider: HSlider = %MusicSlider

@onready var sfx_label: Label = %SfxLabel
@onready var sfx_slider: HSlider = %SfxSlider

func _ready() -> void:
	_update_settings()

func _update_settings() -> void:
	# Displays user's changes to music and SFX volumes using slider values
	music_label.text = "Music Volume: " + str(int(Global.music_volume))
	sfx_label.text = "SFX Volume: " + str(int(Global.sfx_volume))

	music_slider.value = Global.music_volume
	sfx_slider.value = Global.sfx_volume

	# Update the volume on both buses
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"),linear_to_db(Global.music_volume/100))
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"),linear_to_db(Global.sfx_volume/100))

func _on_back_button_pressed() -> void:
	Global.go_to("res://src/MainMenu/MainMenu.tscn")

func _on_reset_button_pressed() -> void:
	Global.music_volume = 100
	Global.sfx_volume = 100

	_update_settings()

func _on_music_slider_value_changed(value: float) -> void:
	Global.music_volume = value
	_update_settings()

func _on_sfx_slider_value_changed(value: float) -> void:
	Global.sfx_volume = value
	_update_settings()
