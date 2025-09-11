extends CharacterBody2D

# player stats
@export var max_hp = 100
@export var hp = 100

# player movement variables
@export var speed = 50
@export var g = 900
@export var jump_force = 200
@export var friction = 0.1

@export var hp_bar: TextureProgressBar 

var cooldown: float 

# player sprite
@onready var sprite = $Sprite2D

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
		player_animation.play("walk")
		sprite.scale.x = -1
		prev_direction = "left"
	if Input.is_action_pressed("right"):
		input_direction += 1
		player_animation.play("walk")
		sprite.scale.x = 1
		prev_direction = "right"
		
	if input_direction != 0:
		velocity.x = input_direction * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		if prev_direction == "right":
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
		player_animation.play("idle")

func check_attack():
	if can_attack and Input.is_action_just_pressed("attack"):
		can_attack = false
		weapon._attack()
		
		await get_tree().create_timer(weapon.cooldown).timeout
		can_attack = true
		
func take_dmg(dmg: int):
	hp -= dmg
	hp_bar.value -= dmg
	

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
	
	if Input.is_action_just_pressed("interact"):
		take_dmg(5)
