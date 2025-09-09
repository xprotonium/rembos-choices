extends CharacterBody2D

# player movement variables
@export var speed = 50
@export var g = 900
@export var jump_force = 200
@export var friction = 0.1

# player weapon
@onready var weapon = $WeaponHolder/Weapon
var can_attack: bool = true

# get the animation player
@onready var player_animation = $PlayerAnimations
var prev_direction = "right"

func get_input():
	var input_direction = 0

	if Input.is_action_pressed("left"):
		input_direction -= 1
		player_animation.play("walk_left")
		prev_direction = "left"
	if Input.is_action_pressed("right"):
		input_direction += 1
		player_animation.play("walk_right")
		prev_direction = "right"
		
	if input_direction != 0:
		velocity.x = input_direction * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		player_animation.play("idle_" + prev_direction)

func check_attack():
	if can_attack and Input.is_action_just_pressed("attack"):
		can_attack = false
		player_animation.play("sword_attack")
		weapon._attack()
		
		await get_tree().create_timer(weapon.cooldown).timeout
		can_attack = true

func _physics_process(delta: float) -> void:
	# get the input direction and apply it
	get_input()
	move_and_slide()
	
	# apply gravity
	velocity.y += g * delta
	
	# jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y -= jump_force
		
	check_attack()
