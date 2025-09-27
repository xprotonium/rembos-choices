extends Node2D


@export var perfect_timing: PackedScene
@export var radius: float = 32.0
@onready var area2D: Area2D = $GateArea
@onready var collision_shape: CollisionShape2D = $GateArea/GateCollision
@onready var gate: AnimatedSprite2D = $"../PuzzleBG/gate_animation"

var player_in_area = false

func _ready():
	# add the radius value from the exported variable.
	var circle := collision_shape.shape as CircleShape2D
	if circle:
		circle.radius = radius

	# connect the signals of area2D to 
	# the player enter and exit detection functions below
	area2D.body_entered.connect(_on_player_enter)
	area2D.body_exited.connect(_on_player_exit)
	
func _on_player_enter(body: Node):
	if body is CharacterBody2D:
		player_in_area = true

func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		player_in_area = false

# once the player is in the area,
# check whether the player has pressed the desired input button
func _process(_delta):
	if player_in_area and Input.is_action_just_pressed("interact"):
		if gate.visible == true : 
			get_tree().change_scene_to_packed(perfect_timing)
