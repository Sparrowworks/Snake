extends Node

@onready var loading_transition: String = "res://src/FadeTransition/FadeTransition.tscn"
@onready var click_player: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
@onready var click_sound: AudioStream = load("res://assets/audio/Interface Soft Button.ogg")

const MOVEMENT_SIZE = 64
const MAX_X = 19
const MAX_Y = 19

var music_volume: int = 100
var sfx_volume: int = 100
var hi_score: int = 0

func _ready() -> void:
	get_tree().root.call_deferred("add_child",click_player)
	click_player.stream = click_sound

func go_to(scene: String) -> void:
	var transition: Node = Composer.setup_load_screen(Global.loading_transition)
	if transition:
		click_player.play()
		await transition.finished_fade_in
		Composer.load_scene(scene)
