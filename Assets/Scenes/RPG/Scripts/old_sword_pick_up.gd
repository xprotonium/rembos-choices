extends Node2D

@export var weapon_data: WeaponData
@export var weapon_scene: PackedScene
@export var sword_in_pedestal: Texture2D
@export var pedestal: Texture2D
@export var world_text: Label
@export var pickup_ui: CanvasLayer

@onready var current_sprite = $Sprite2D
@onready var interact_sprite = $InteractSprite
@onready var area2d = $Area2D

var taken = false

var player_in_area: CharacterBody2D = null

func _ready() -> void:
	interact_sprite.visible = false
	world_text.text = "Take up the blade"
	current_sprite.texture = sword_in_pedestal
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)


func _on_body_entered(body: Node) -> void:
	if taken:
		return
	if body is CharacterBody2D:
		player_in_area = body
		interact_sprite.visible = true


func _on_body_exited(body: Node) -> void:
	if taken:
		return
	if body == player_in_area:
		player_in_area = null
		interact_sprite.visible = false


func _process(_delta: float) -> void:
	if taken == false and player_in_area and Input.is_action_just_pressed("interact"):
		# Save the scene path in the player inventory
		if not player_in_area.inventory.has(weapon_data.item_name):
			player_in_area.inventory[weapon_data.item_name] = weapon_scene.resource_path
			print("Picked up: ", weapon_data.item_name)
		else:
			print("Already in inventory: ", weapon_data.item_name)

		# Equip weapon by name
		player_in_area.equip_weapon(weapon_data.item_name)
		current_sprite.texture = pedestal
		pickup_ui._show_pickup_info(weapon_data.item_icon, weapon_data.item_description)
		world_text.text = "Take up the blade\n Now venture on.. O lost one."
		taken = true
		interact_sprite.visible = false
