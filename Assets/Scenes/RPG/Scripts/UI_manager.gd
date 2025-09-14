extends CanvasLayer

@onready var hp_bar = $Control/MarginContainer/HP/TextureProgressBar
@onready var hp_text = $Control/MarginContainer/HP/Label
@onready var pickup_ui = $Control/PickUpInfo
@onready var item_sprite = $Control/PickUpInfo/HBoxContainer/TextureRect
@onready var item_description = $Control/PickUpInfo/HBoxContainer/Label

# get the player hp
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	player = get_node(player_path)
	hp_bar.max_value = player.max_hp
	hp_bar.value = player.hp
	hp_text.text = str(player.hp)
	pickup_ui.visible = false

func _show_pickup_info(texture: Texture2D, description: String):
	pickup_ui.visible = true
	item_sprite.texture = texture
	item_description.text = description

func _on_button_pressed() -> void:
	pickup_ui.visible = false
