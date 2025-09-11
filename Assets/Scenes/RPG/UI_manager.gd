extends CanvasLayer

@onready var hp_bar = $Control/MarginContainer/Panel/TextureProgressBar

# get the player hp
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	player = get_node(player_path)
	hp_bar.max_value = player.max_hp
	hp_bar.value = player.hp
