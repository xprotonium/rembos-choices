extends Area2D

@onready var e_key_button = $Sprite2D
var is_in_area = false

func _ready() -> void:
	is_in_area = false
	e_key_button.visible = false

func _process(delta: float) -> void:
	if is_in_area and Input.is_action_just_pressed("interact"):
		MainGameManager.sleep()

func _on_body_entered(body: Node2D) -> void:
	if body == MainGameManager.player:
		e_key_button.visible = true
		is_in_area = true


func _on_body_exited(body: Node2D) -> void:
	if body == MainGameManager.player:
		e_key_button.visible = false
		is_in_area = false
