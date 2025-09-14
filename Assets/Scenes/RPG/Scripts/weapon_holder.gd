extends Node2D

# change the position of the weapon holder 
# based on the direction the player is facing

# player
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	player = get_node(player_path)

func _process(_delta: float) -> void:
	if player.prev_direction == "left":
		scale.x = -1
		position.x = -4
	else:
		scale.x = 1
		position.x = 4
