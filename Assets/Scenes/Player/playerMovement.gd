extends CharacterBody2D

@export var speed = 50
var allow_movement = true

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _physics_process(_delta):
	if allow_movement:
		get_input()
		move_and_slide()
