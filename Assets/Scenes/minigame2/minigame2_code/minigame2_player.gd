extends CharacterBody2D

@export var jump_force: float = -200.0
@export var gravity: float = 900.0
@onready var player_animations = $Sprite2D/AnimationPlayer

var is_invincible = false
var invincibility_timer = 0.0

func _ready() -> void:
	player_animations.play("C57_run")

func _physics_process(delta):
	# ===== UPDATE INVINCIBILITY TIMER FIRST =====
	if is_invincible:
		invincibility_timer -= delta
		if invincibility_timer <= 0:
			is_invincible = false
			print("Invincibility ended!")
	# ============================================
	
	if position.x < -64:
		print("GAME OVER! Player went too far left")
		game_over()
		return 
	
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = jump_force
	
	velocity.y += gravity * delta
	move_and_slide()
	
	# SIMPLE FLOOR AT Y=40
	if position.y > 60:
		position.y = 60
		velocity.y = 0
	
	position.y = max(position.y, -82)
	
	# ===== MOVE INVINCIBILITY CHECK HERE =====
	if not is_invincible:  # ← CHECK BEFORE COLLISION DETECTION
		check_obstacle_collisions()
	# ========================================

func check_obstacle_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("obstacles"):
			print("GAME OVER! Player hit obstacle")
			game_over()
			break

func start_invincibility(duration: float):
	print("Player became invincible for ", duration, " seconds!")
	is_invincible = true
	invincibility_timer = duration

func game_over():
	print("PLAYER: Game over triggered!")
	set_physics_process(false)
	
	# Stop score tracking - UPDATED
	var score_system = get_node("../ScoreSystem")
	if score_system:
		if score_system.has_method("stop_scoring"):
			score_system.stop_scoring()
		else:
			print("ScoreSystem exists but doesn't have stop_scoring method")
	else:
		print("ScoreSystem node not found!")
	
	var spawner = get_node("../Spawner")
	if spawner and spawner.has_method("stop_spawning"):
		spawner.stop_spawning()
	
	for obstacle in get_tree().get_nodes_in_group("obstacles"):
		obstacle.set_physics_process(false)
		obstacle.set_process(false)
	
	for ability in get_tree().get_nodes_in_group("abilities"):
		ability.set_physics_process(false)
		ability.set_process(false)
	
	var controller = get_parent()
	if controller and controller.has_method("game_over"):
		controller.game_over()
	
	print("EVERYTHING STOPPED - NO LOOPING")
