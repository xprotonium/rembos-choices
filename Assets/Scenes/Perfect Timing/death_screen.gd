extends Control

@onready var respawn_btn = $Panel/HBoxContainer/Respawn
@onready var quit_btn = $Panel/HBoxContainer/Quit
@onready var battle_result = $Panel/Label
@export var player: Node2D
@export var enemy: Node2D

func _process(_delta: float) -> void:
	if player.hp == 0:
		battle_result.text = "YOU LOSE"
	if enemy.hp == 0:
		battle_result.text = "YOU WIN"
		MainGameManager.advance_stage()
		

func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()



func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
