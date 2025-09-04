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
	
	var screen_size = get_viewport_rect().size
	position.y = clamp(position.y, -82, screen_size.y)
