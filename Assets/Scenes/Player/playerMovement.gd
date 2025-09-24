extends CharacterBody2D

@export var speed = 50
var allow_movement = true
@onready var player_animations = $Sprite2D/PlayerAnimations
var prev_direction = "down"

@onready var game_manager = get_node("/root/MainGameManager")

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	# Example: slow movement if tired
	var actual_speed = speed
	if game_manager.energy <= 3:
		actual_speed = speed * 0.5

	velocity = input_direction * actual_speed

func player_animation_manager():
	if Input.is_action_pressed("up"):
		player_animations.play("walk_up")
		prev_direction = "up"
	elif Input.is_action_pressed("down"):
		player_animations.play("walk_down")
		prev_direction = "down"
	elif Input.is_action_pressed("left"):
		player_animations.play("walk_left")
		prev_direction = "left"
	elif Input.is_action_pressed("right"):
		player_animations.play("walk_right")
		prev_direction = "right"
	else:
		player_animations.play("idle_" + prev_direction)

func _physics_process(_delta):
	if allow_movement:
		get_input()
		move_and_slide()

func _process(_delta: float) -> void:
	player_animation_manager()
