extends CharacterBody2D

# player variables
@export var speed = 65
@export var g = 900
@export var jump_force = 225

# get the animation player
@onready var player_animation = $Sprite2D/AnimationPlayer
var prev_direction = "right"

func get_input():
	var input_direction = 0

	if Input.is_action_pressed("left"):
		input_direction -= 1
	if Input.is_action_pressed("right"):
		input_direction += 1
		
	velocity.x = input_direction * speed

func _physics_process(delta: float) -> void:
	# get the input direction and apply it
	get_input()
	move_and_slide()
	
	# apply gravity
	velocity.y += g * delta
	
	# jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y -= jump_force
