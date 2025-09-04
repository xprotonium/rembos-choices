extends CharacterBody2D

# player speed
@export var speed = 50

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
	get_input()
	move_and_slide()
