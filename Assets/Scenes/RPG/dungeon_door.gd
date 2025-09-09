extends Node2D

# modified version of the proximity button for TMON
# check door lock status and change the ui icon based on if the 
# player got the key/ solved the puzzle


# public field for changing the collision size.
# Collision variables
@export var radius = 6
@onready var area2D: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
var player_in_area = false

# TextureRect for displaying the button the user has to click
@onready var texture: TextureRect = $TextureRect

# UI lock icon texture
@export var ui_locked_texture: Texture2D
@export var ui_unlocked_texture: Texture2D

# Door Sprites
@onready var door = $Sprite2D
@export var door_locked: Texture2D
@export var door_unlocked: Texture2D

# door
var is_door_locked = true

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
	if player_in_area and Input.is_action_just_pressed("interact") and not is_door_locked:
		print("woohoo")
		
func door_lock_manager():
	if door_locked:
		texture.texture = ui_locked_texture
		door.texture = door_locked
	else:
		texture.texture = ui_unlocked_texture
		door.texture = door_unlocked
