extends Area2D

@export var speed: float = 600.0
@export var remove_x: float = -300.0

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Ability picked up! +99G!")
		
		# Create floating text effect for G above the robot coin counter
		create_floating_text("+99G")
		
		# Add 99G to the robot coin
		var score_system = get_node("/root/ScoreSystem")
		if score_system:
			score_system.add_robot_coin(99)
		else:
			# Alternative path if ScoreSystem is not at root
			score_system = get_node("../score_system")
			if score_system:
				score_system.add_robot_coin(99)
			else:
				print("ScoreSystem not found!")
		
		queue_free()

func create_floating_text(text: String):
	# Create a label for the floating text
	var floating_text = Label.new()
	floating_text.text = text
	floating_text.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	floating_text.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	
	# Style the text to be very small
	floating_text.add_theme_font_size_override("font_size", 8)
	floating_text.add_theme_color_override("font_color", Color.GOLD)
	floating_text.add_theme_constant_override("outline_size", 1)
	floating_text.add_theme_color_override("font_outline_color", Color.DARK_GOLDENROD)
	
	# Add directly to the current scene
	get_tree().current_scene.add_child(floating_text)
	
	# Position the text above the robot coin counter
	var viewport_size = get_viewport().get_visible_rect().size
	floating_text.position = Vector2(viewport_size.x / 2 - 15, viewport_size.y - 40)
	
	# Simple timer to remove after 1 second
	var timer = Timer.new()
	add_child(timer)
	timer.wait_time = 1.0
	timer.one_shot = true
	timer.timeout.connect(floating_text.queue_free)
	timer.timeout.connect(timer.queue_free)
	timer.start()
