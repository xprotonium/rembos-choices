extends Node2D

@export var pickup_sprite: Texture2D
@export var weapon_data: WeaponData
@export var player_path: NodePath

@onready var sprite = $Sprite2D

func _ready() -> void:
	sprite.texture = pickup_sprite
	var player = get_node(player_path)
	
