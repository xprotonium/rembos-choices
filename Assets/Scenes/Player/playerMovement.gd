extends CharacterBody2D

@export var speed: float = 50
var allow_movement: bool = true

@onready var player_animations = $Sprite2D/PlayerAnimations
var prev_direction: String = "down"

# Reference to the global GameManager singleton
@onready var game_manager = get_node("/root/MainGameManager")

# -------------------- LIFECYCLE --------------------
func _ready() -> void:
	# Register this player in the GameManager
	MainGameManager.set_player(self)

	# Restore position if saved
	if MainGameManager.player_position != Vector2.ZERO:
		global_position = MainGameManager.player_position

# -------------------- MOVEMENT --------------------
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")

	# Example: slow movement if tired
	var actual_speed = speed
	if game_manager.energy <= 3:
		actual_speed = speed * 0.5

	velocity = input_direction * actual_speed

func _physics_process(_delta: float) -> void:
	if not allow_movement:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	get_input()
	move_and_slide()

# -------------------- ANIMATIONS --------------------
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

func _process(_delta: float) -> void:
	if allow_movement:
		player_animation_manager()

# -------------------- GAME MANAGER INTEGRATION --------------------
func save_position() -> void:
	MainGameManager.player_position = global_position
	MainGameManager.has_saved_position = true

func set_allow_movement(enable: bool) -> void:
	allow_movement = enable
