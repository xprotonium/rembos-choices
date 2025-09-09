extends Node2D

func _ready():
	pass  # Keep it simple

func game_over():
	print("GAME OVER FROM CONTROLLER")
	
	# Stop everything
	get_tree().paused = true  # This instantly pauses everything
	
	# Optional: Show game over UI after a delay
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	get_tree().reload_current_scene()
