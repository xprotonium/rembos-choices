extends CharacterBody2D

@export var jump_force: float = -225.0
@export var gravity: float = 900.0
@onready var player_animations = $Sprite2D/AnimationPlayer


var jump_queue_timer = 0.0
var jump_queued = false

func _ready() -> void:
	player_animations.play("C57_run")

func _physics_process(delta):

	if jump_queued:
		jump_queue_timer -= delta
		if jump_queue_timer <= 0:
			velocity.y = jump_force
			jump_queued = false
			print("Delayed jump executed - Energy: ", MainGameManager.energy)
	
	if position.x < -64:
		print("GAME OVER! Player went too far left")
		game_over()
		return 
	
	# Input delay based on energy
	if Input.is_action_just_pressed("ui_accept"):
		if MainGameManager.energy <= 7:
			jump_queued = true
			jump_queue_timer = 0.275 if MainGameManager.energy <= 4 else 0.175
			print("Jump queued - will execute in ", jump_queue_timer, "s - Energy: ", MainGameManager.energy)
		else:
			# Normal jumping without delay
			velocity.y = jump_force
			print("Normal jump - Energy: ", MainGameManager.energy)
	
	velocity.y += gravity * delta
	move_and_slide()
	
	# SIMPLE FLOOR AT Y=40
	if position.y > 60:
		position.y = 60
		velocity.y = 0
	
	position.y = max(position.y, -82)
	

func check_obstacle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("obstacles"):
			print("GAME OVER! Player hit obstacle")
			game_over()
			break


func game_over():
	print("PLAYER: Game over triggered!")
	set_physics_process(false)
	
	# Stop score tracking
	var score_system = get_node("../ScoreSystem")
	if score_system and score_system.has_method("stop_scoring"):
		score_system.stop_scoring()
	
	var spawner = get_node("../Spawner")
	if spawner and spawner.has_method("stop_spawning"):
		spawner.stop_spawning()
	
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		obstacle.set_physics_process(false)
	
	for ability in get_tree().get_nodes_in_group("abilities"):
		ability.set_physics_process(false)
	
	var controller = get_parent()
	if controller and controller.has_method("game_over"):
		controller.game_over()
	
	print("EVERYTHING STOPPED")
	
	
