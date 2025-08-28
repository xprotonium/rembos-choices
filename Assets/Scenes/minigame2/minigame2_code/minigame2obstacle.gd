extends CharacterBody2D

@export var speed: float = 200.0

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < -100:
		queue_free()
