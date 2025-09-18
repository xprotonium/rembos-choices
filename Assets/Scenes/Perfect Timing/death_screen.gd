extends Control

@onready var respawn_btn = $Panel/HBoxContainer/Respawn
@onready var quit_btn = $Panel/HBoxContainer/Quit



func _on_respawn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()



func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
