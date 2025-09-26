extends Node2D

@onready var intro_player: AnimationPlayer = $AnimationPlayer
@onready var player: CharacterBody2D = $Player/CharacterBody2D

func _ready() -> void:
	player.allow_movement = false  
	intro_player.play("intro")
	intro_player.animation_finished.connect(_on_intro_finished)

func _on_intro_finished(anim_name: String) -> void:
	if anim_name == "intro":
		player.allow_movement = true
		MainGameManager.advance_stage()
