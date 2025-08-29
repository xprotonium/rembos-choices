extends Area2D

@export var speed: float = 200.0
@export var remove_x: float = -300 

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()
