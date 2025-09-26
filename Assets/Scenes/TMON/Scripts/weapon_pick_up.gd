extends Node2D

@export var weapon_data: WeaponData
@export var weapon_scene: PackedScene

@onready var pick_up_sprite = $Sprite2D
@onready var area2d = $Area2D

var player_in_area: CharacterBody2D = null

func _ready() -> void:
	pick_up_sprite.texutre = weapon_data.item_icon
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		player_in_area = body

func _on_body_exited(body: Node) -> void:
	if body == player_in_area:
		player_in_area = null
		
func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		# Save the scene path in the player inventory
		if not player_in_area.inventory.has(weapon_data.item_name):
			player_in_area.inventory[weapon_data.item_name] = weapon_scene.resource_path

		# Equip weapon by name
		player_in_area.equip_weapon(weapon_data.item_name)
		queue_free()
