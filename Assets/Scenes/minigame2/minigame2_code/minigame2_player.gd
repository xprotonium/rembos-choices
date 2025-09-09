extends CharacterBody2D

@export var jump_force: float = -200.0
@export var gravity: float = 900.0
@onready var player_animations = $Sprite2D/AnimationPlayer

func _ready() -> void:
	player_animations.play("C57_run")

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force
	
	velocity.y += gravity * delta
	move_and_slide()
	
	# SIMPLE FLOOR AT Y=40
	if position.y > 60:
		position.y = 60
		velocity.y = 0
	
	position.y = max(position.y, -82)
	
	# Check for obstacle collisions
	check_obstacle_collisions()

func check_obstacle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("obstacles"):
			print("GAME OVER! Player hit obstacle")
			game_over()
			break  # Stop checking after first collision

func game_over():
	# Stop player movement
	set_physics_process(false)
	
	# Stop all obstacles from spawning
	var spawner = get_node("../Spawner")
	if spawner and spawner.has_method("stop_spawning"):
		spawner.stop_spawning()
	
	# Stop all existing obstacles
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		obstacle.set_physics_process(false)
		obstacle.set_process(false)
	
	# Stop all abilities
	for ability in get_tree().get_nodes_in_group("abilities"):
		ability.set_physics_process(false)
		ability.set_process(false)
	
	# Call game over on main controller
	var main = get_parent()
	if main and main.has_method("game_over"):
		main.game_over()
	
	print("ALL ACTIONS STOPPED - GAME OVER")
