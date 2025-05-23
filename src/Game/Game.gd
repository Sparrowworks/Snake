extends Node2D

signal game_paused()

@onready var score_label: Label = %ScoreLabel
@onready var time_label: Label = %TimeLabel
@onready var hi_label: Label = %HiLabel

@onready var game_over_panel: TextureRect = %GameOverPanel
@onready var new_score: Label = %NewScore

var score: int = 0:
	set(val):
		score = val
		score_label.text = "Score: " + str(score) # Update the label on variable change

var time: int = 0:
	set(val):
		time = val
		time_label.text = "Time: " + str(time) # Update the label on variable change

var is_game_over: bool = false

func _ready() -> void:
	# Show the previous high score
	hi_label.text = "HI Score: " + str(Globals.hi_score)
	%GameTheme.play()

func show_game_over() -> void:
	# If we get a new high score, show an appropriate message
	if Globals.is_new_high_score(score):
		%NewScore.show()

	# Show the game over panel
	game_over_panel.show()
	game_over_panel.modulate = Color.TRANSPARENT

	var game_over_tween: Tween = get_tree().create_tween()
	game_over_tween.tween_property(game_over_panel,"modulate:a",1.0,1.5)
	game_over_tween.tween_callback(
		func() -> void:
			set_process(true)
			game_over_tween.kill()
	)

func _on_time_timer_timeout() -> void:
	time += 1

func _on_apple_score_increased(amount: int) -> void:
	score += amount

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("quit"):
		Globals.go_to("res://src/MainMenu/MainMenu.tscn")

	if Input.is_action_just_pressed("reset"):
		Globals.go_to("res://src/Game/Game.tscn")

	if Input.is_action_just_pressed("pause"):
		set_process_input(false)
		get_tree().paused = true
		game_paused.emit()

	if Input.is_action_just_pressed("mute"):
		if %GameTheme.playing:
			%GameTheme.stop()
		else:
			%GameTheme.play()

func _on_snake_game_over() -> void:
	if is_game_over: return

	%GameTheme.stop()

	is_game_over = true
	set_process(false)
	$TimeTimer.stop()

	%GameOver.play()
	await get_tree().create_timer(2).timeout
	show_game_over()


func _on_pause_ui_game_unpaused() -> void:
	get_tree().paused = false
	Globals.click_player.play()

	await get_tree().create_timer(0.5).timeout
	set_process_input(true)
