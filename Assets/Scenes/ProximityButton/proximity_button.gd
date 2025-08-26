extends Node2D

# public field for changing the collision size.
# Collision variables
@export var radius: float = 32.0
@onready var area2D: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
var player_in_area = false

@export var ui_path: NodePath
var ui: Control

# TextureRect for displaying the button the user has to click
@onready var texture: TextureRect = $TextureRect

func _ready():
	# add the radius value from the exported variable.
	texture.visible = false
	var circle := collision_shape.shape as CircleShape2D
	
	if circle:
		circle.radius = radius
	# connect the signals of area2D to 
	# the player enter and exit detection functions below
	area2D.body_entered.connect(_on_player_enter)
	area2D.body_exited.connect(_on_player_exit)
	
	# get the ui path
	ui = get_node(ui_path)
	
func _on_player_enter(body: Node):
	if body is CharacterBody2D:
		print("Player entered the area")
		texture.visible = true
		player_in_area = true

func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		print("Player exited the area")
		texture.visible = false
		player_in_area = false

# once the player is in the area,
# check whether the player has pressed the desired input button
func _process(_delta):
	if player_in_area && Input.is_action_just_pressed("interact"):
		ui.visible = true
