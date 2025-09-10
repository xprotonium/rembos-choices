extends Area2D

@export var speed: float = 300.0
@export var remove_x: float = -500.0

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Ability picked up! Disabling obstacle collisions for 10 seconds")
		
		# Disable collision on ALL obstacles (works for both Area2D and CharacterBody2D)
		for obstacle in get_tree().get_nodes_in_group("obstacles"):
			# Check if obstacle has CollisionShape2D
			if obstacle.has_node("CollisionShape2D"):
				var collision_shape = obstacle.get_node("CollisionShape2D")
				collision_shape.disabled = true
				print("Disabled collision on obstacle")
				
				# Re-enable after duration
				await get_tree().create_timer(10.0).timeout
				collision_shape.disabled = false
				print("Re-enabled collision on obstacle")
		
		queue_free()
