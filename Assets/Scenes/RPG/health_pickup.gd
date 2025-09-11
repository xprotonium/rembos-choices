extends Node2D

@export var pick_up_sprite: Texture2D
@export var hp_bar: TextureProgressBar
@export var hp_bar_text: Label
@export var heal_amount = 25

# get the player hp
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	player = get_node(player_path)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if player.hp < player.max_hp:
		# clamp the healing so it does not go past max hp
		player.hp = min(player.hp + heal_amount, player.max_hp)
		hp_bar.value = player.hp
		hp_bar_text.text = str(player.hp)
		queue_free()
