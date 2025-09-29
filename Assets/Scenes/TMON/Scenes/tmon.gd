extends Node2D

func _process(delta: float) -> void:
	if MainGameManager.hunger == 0:
		get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
