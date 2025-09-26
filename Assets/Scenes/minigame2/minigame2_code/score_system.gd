extends Node

var counter: int = 0
var high_score: int = 0
var robot_coin: int = 0  
var timer: Timer
var label: Label
var high_score_label: Label
var robot_coin_label: Label 
var is_counting: bool = false
var start_text: Label
var game_over_text: Label
var can_restart: bool = false
var start_canvas_layer: CanvasLayer
var game_over_canvas_layer: CanvasLayer
@export var win_text: Label

func _ready():
	# Load high score and robot coin from file
	load_high_score()
	print(MainGameManager.gold)
	
	# Create the score display label
	label = Label.new()
	label.text = "SCORE: 0"
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	
	# Style it to be visible
	label.add_theme_font_size_override("font_size", 10)
	label.add_theme_color_override("font_color", Color.ORANGE_RED)
	label.add_theme_constant_override("outline_size", 2)
	label.add_theme_color_override("font_outline_color", Color.DARK_RED)
	
	# Create high score label
	high_score_label = Label.new()
	high_score_label.text = "HIGH SCORE: " + str(high_score)
	high_score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	high_score_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	
	# Style high score
	high_score_label.add_theme_font_size_override("font_size", 10)
	high_score_label.add_theme_color_override("font_color", Color.GREEN)
	high_score_label.add_theme_constant_override("outline_size", 2)
	high_score_label.add_theme_color_override("font_outline_color", Color.DARK_GREEN)
	
	# NEW: Create robot coin label
	robot_coin_label = Label.new()
	robot_coin_label.text = "G: " + str(robot_coin)
	robot_coin_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	robot_coin_label.vertical_alignment = VERTICAL_ALIGNMENT_BOTTOM
	
	# Style robot coin label
	robot_coin_label.add_theme_font_size_override("font_size", 10)
	robot_coin_label.add_theme_color_override("font_color", Color.GOLD)
	robot_coin_label.add_theme_constant_override("outline_size", 2)
	robot_coin_label.add_theme_color_override("font_outline_color", Color.DARK_GOLDENROD)
	
	# Add to CanvasLayer to ensure it's on top
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	canvas_layer.add_child(label)
	canvas_layer.add_child(high_score_label)
	canvas_layer.add_child(robot_coin_label)  # NEW: Add robot coin label
	add_child(canvas_layer)
	
	# Create timer (but don't start it yet)
	timer = Timer.new()
	timer.wait_time = 0.0001  # 1ms
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)
	
	# Create "Press Space to Start" text
	create_start_text()
	
	# Position labels
	_update_label_positions()
	
	# Enable input processing
	set_process(true)

func _process(_delta):
	# Check for spacebar to start counting
	if not is_counting and Input.is_action_just_pressed("ui_accept"):
		if can_restart:
			restart_game()
		else:
			start_counting()

	
	# Check if game is over (player went too far left)
	check_game_over()
	
	# NEW: Press 0 to reset high score AND robot coin to 0
	if Input.is_key_pressed(KEY_0):
		high_score = 0
		robot_coin = 0  
		high_score_label.text = "HIGH SCORE: 0"
		robot_coin_label.text = "G: 0" 
		save_high_score()
		print("High score and robot coin manually reset to 0")
		
func check_game_over():
	# Simple player check - FIXED: Check if tree exists first
	if not is_counting:
		return
		
	var player = null
	if has_node("/root/Player"):
		player = get_node("/root/Player")
	elif has_node("../Player"):
		player = get_node("../Player")
	elif has_node("Player"):
		player = get_node("Player")
	
	if player and player is Node2D and player.position.x < -64:
		stop_scoring()

func start_counting():
	is_counting = true
	counter = 0  
	can_restart = false
	
	# Remove start text
	remove_start_text()
	
	# Start timer
	timer.start()
	print("Score started!")

func stop_scoring():
	is_counting = false
	timer.stop()
	
	var coins_earned = counter / 5000
	if coins_earned > 0:
		robot_coin += coins_earned
		MainGameManager.gold += coins_earned
		robot_coin_label.text = "G: " + str(robot_coin) 
		print("Earned ", coins_earned, "G! Total G: ", robot_coin)
	
	# Check for new high score
	if counter > high_score:
		high_score = counter
		high_score_label.text = "HIGH SCORE: " + str(high_score)
		save_high_score()
		print("NEW HIGH SCORE! ", high_score)
	else:
		print("Final score: ", counter)
	
	# Show game over text and enable restart after 2 seconds
	show_game_over_text()
	
	# check if the player can proceed to next minigame
	if counter >= 10000 and MainGameManager.current_stage == MainGameManager.QuestStage.PLAY_C57:
		MainGameManager.advance_stage()

func show_game_over_text():
	# Create "Press Space to Restart" text after 0.5 seconds
	await get_tree().create_timer(0.5).timeout
	
	game_over_text = Label.new()
	game_over_text.text = "GAME OVER!"
	game_over_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	game_over_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Make it large and visible
	game_over_text.add_theme_font_size_override("font_size", 36)
	game_over_text.add_theme_color_override("font_color", Color.RED)
	game_over_text.add_theme_constant_override("outline_size", 4)
	game_over_text.add_theme_color_override("font_outline_color", Color.DARK_RED)
	
	# Add to canvas with high layer to ensure it's visible
	game_over_canvas_layer = CanvasLayer.new()
	game_over_canvas_layer.layer = 102  # Highest layer
	
	# ADD THE CANVAS LAYER TO SCENE FIRST
	add_child(game_over_canvas_layer)
	
	# THEN add the game over text to it
	game_over_canvas_layer.add_child(game_over_text)
	
	# Center the text
	var viewport_size = get_viewport().get_visible_rect().size
	game_over_text.position = Vector2(viewport_size.x / 2 - 110, viewport_size.y / 2 - 40)
	
	if counter >= 10000:
		show_unlock_text(viewport_size)
	
	can_restart = true
	print("Ready for restart - Press Spacebar")

func show_unlock_text(viewport_size: Vector2):
	var unlock_text = Label.new()
	unlock_text.text = "NEXT MINIGAME UNLOCKED!!"
	unlock_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	unlock_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style with light green color
	unlock_text.add_theme_font_size_override("font_size", 16)
	unlock_text.add_theme_color_override("font_color", Color.LIGHT_GREEN)
	unlock_text.add_theme_constant_override("outline_size", 4)
	unlock_text.add_theme_color_override("font_outline_color", Color.DARK_GREEN)
	
	# Add to the same game over canvas layer (which is now in the scene)
	game_over_canvas_layer.add_child(unlock_text)
	
	# Position slightly under the GAME OVER text
	unlock_text.position = Vector2(viewport_size.x / 2 - 115, viewport_size.y / 2)
	
	print("Next minigame unlocked! Score: ", counter)

func restart_game():
	print("Restarting game by reloading scene...")
	get_tree().reload_current_scene()

func remove_start_text():
	if start_text and is_instance_valid(start_text):
		start_text.queue_free()
		start_text = null
	if start_canvas_layer and is_instance_valid(start_canvas_layer):
		start_canvas_layer.queue_free()
		start_canvas_layer = null

func remove_game_over_text():
	if game_over_text and is_instance_valid(game_over_text):
		game_over_text.queue_free()
		game_over_text = null
	if game_over_canvas_layer and is_instance_valid(game_over_canvas_layer):
		game_over_canvas_layer.queue_free()
		game_over_canvas_layer = null

func _on_timer_timeout():
	if is_counting:
		counter += 12.34
		label.text = "SCORE: " + str(counter)
		_update_label_positions()

func _update_label_positions():
	# Keep score in bottom right corner
	var viewport_size = get_viewport().get_visible_rect().size
	label.position = Vector2(viewport_size.x - 80, viewport_size.y - 15)
	
	# Keep high score in bottom left corner
	high_score_label.position = Vector2(10, viewport_size.y - 15)
	
	# NEW: Keep robot coin in bottom center
	robot_coin_label.position = Vector2(viewport_size.x / 2 - 20, viewport_size.y - 15)

func create_start_text():
	# Create "Press Space to Start" text
	start_text = Label.new()
	start_text.text = "PRESS SPACEBAR TO START"
	start_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	start_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Make it large and visible
	start_text.add_theme_font_size_override("font_size", 15)
	start_text.add_theme_color_override("font_color", Color.YELLOW)
	start_text.add_theme_constant_override("outline_size", 2)
	start_text.add_theme_color_override("font_outline_color", Color.BLACK)
	
	# Add to canvas with high layer to ensure it's visible
	start_canvas_layer = CanvasLayer.new()
	start_canvas_layer.layer = 101  # Even higher than the counter
	start_canvas_layer.add_child(start_text)
	add_child(start_canvas_layer)
	
	# Center the text
	var viewport_size = get_viewport().get_visible_rect().size
	start_text.position = Vector2(viewport_size.x / 2 - 95, viewport_size.y / 2 - 80)

func get_score() -> int:
	return counter

# NEW: Get robot coin count
func get_robot_coin() -> int:
	return robot_coin

func load_high_score():
	var file = FileAccess.open("user://high_score.dat", FileAccess.READ)
	if file:
		high_score = file.get_32()
		file.close()
		print("Loaded high score: ", high_score)
	else:
		high_score = 0
		print("No high score file found, starting fresh")

func save_high_score():
	var file = FileAccess.open("user://high_score.dat", FileAccess.WRITE)
	if file:
		file.store_32(high_score)
		file.close()
		print("Saved high score: ", high_score)


		
func add_score(amount: int):
	if is_counting:
		counter += amount
		label.text = "SCORE: " + str(counter)
		_update_label_positions()
		print("Added ", amount, " points! Total: ", counter)
		
# Add this function to your score_system.gd
func add_robot_coin(amount: int):
	robot_coin += amount
	robot_coin_label.text = "G: " + str(robot_coin)
	MainGameManager.gold += amount
	print("Added ", amount, "G! Total G: ", robot_coin)
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
