extends Node

@onready var loading_transition: String = "res://src/FadeTransition/FadeTransition.tscn"

const MOVEMENT_SIZE = 64
const MAX_X = 19
const MAX_Y = 19

var music_volume: int = 100
var sfx_volume: int = 100
var hi_score: int = 0
