extends Sprite2D

var player_in_area = false
# DEMO VERSION ONLY

func _process(delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		MainGameManager.advance_stage()
		get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		player_in_area = true
