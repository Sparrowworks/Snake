extends Node

@onready var loading_transition: String = "res://src/FadeTransition/FadeTransition.tscn"

@onready var music_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var click_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()

@onready var click_sound: AudioStream = load("res://assets/audio/click.mp3")
@onready var menu_theme: AudioStream = load("res://assets/audio/menuTheme.mp3")

const MOVEMENT_SIZE = 64
const MAX_X = 19
const MAX_Y = 19

var music_volume: float = 100.0
var sfx_volume: float = 100.0
var hi_score: int = 0

func _ready() -> void:
	# Setup for music player and the button click sound
	get_tree().root.call_deferred("add_child", click_player)
	get_tree().root.call_deferred("add_child", music_player)

	# Set the correct bus for the settings to work
	click_player.bus = "SFX"
	click_player.stream = click_sound
	click_player.process_mode = Node.PROCESS_MODE_ALWAYS

	music_player.bus = "Music"
	music_player.stream = menu_theme

func is_new_high_score(new_score: int) -> bool:
	if new_score > hi_score:
		hi_score = new_score
		return true

	return false

func play_menu_theme() -> void:
	if not music_player.is_inside_tree():
		await music_player.ready

	if music_player.playing: return

	music_player.play()

func stop_menu_theme() -> void:
	music_player.stop()

func go_to(scene: String) -> void:
	var transition: Node = Composer.setup_load_screen(Globals.loading_transition)
	if transition:
		click_player.play()
		await transition.finished_fade_in
		Composer.load_scene(scene)
