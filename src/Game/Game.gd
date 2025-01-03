extends Node2D

@onready var score_label: Label = %ScoreLabel
@onready var time_label: Label = %TimeLabel

var score: int = 0:
	set(val):
		score = val
		score_label.text = "Score: " + str(score)


var time: int = 0:
	set(val):
		time = val
		time_label.text = "Time: " + str(time)

var is_game_over: bool = false

func _on_time_timer_timeout() -> void:
	time += 1


func _on_apple_score_increased(amount: int) -> void:
	score += amount


func _on_snake_game_over() -> void:
	if is_game_over: return

	is_game_over = true
	$TimeTimer.stop()
	print("Game Over")
