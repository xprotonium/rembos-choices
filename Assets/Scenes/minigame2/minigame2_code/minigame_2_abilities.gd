extends Area2D

@export var speed: float = 300.0
@export var remove_x: float = -500.0

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
