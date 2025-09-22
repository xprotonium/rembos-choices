extends CharacterBody2D

@export var speed: float = 300.0
@export var remove_x: float = -500.0

func _ready():
	print("OBSTACLE CREATED at position: ", position)
	print("Obstacle has Sprite2D: ", has_node("Sprite2D"))
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		print("Sprite texture: ", sprite.texture != null)
		print("Sprite visible: ", sprite.visible)

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("PLAYER HIT! Telling player to game over...")
		# Call game_over on the player
		if body.has_method("game_over"):
			body.game_over()
		queue_free()

# ===== ADD THIS FUNCTION =====
func disable_collision_temporarily(duration: float):
	print("Obstacle collision disabled for ", duration, " seconds")
	# Disable collision
	$CollisionShape2D.disabled = true
	
	# Optional: Add visual effect (make semi-transparent)
	if has_node("Sprite2D"):
		$Sprite2D.modulate.a = 0.5  # Make semi-transparent
	
	# Wait for duration
	await get_tree().create_timer(duration).timeout
	
	# Re-enable collision
	$CollisionShape2D.disabled = false
	
	# Optional: Restore visual
	if has_node("Sprite2D"):
		$Sprite2D.modulate.a = 1.0  # Make fully visible again
	
	print("Obstacle collision re-enabled")
# =============================
func set_speed(new_speed: float):
	speed = new_speed
	print("Obstacle speed set to: ", speed)
