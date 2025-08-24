extends Node2D

# public field for changing the collision size.
@export var radius: float = 32.0
@onready var area2D: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

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
		print("Player entered the area")

func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		print("Player exited the area")
