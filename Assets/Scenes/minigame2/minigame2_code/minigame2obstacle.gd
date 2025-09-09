extends CharacterBody2D

@export var speed: float = 300.0
@export var remove_x: float = -500.0

func _ready():
	print("OBSTACLE CREATED at position: ", position)
	print("Obstacle has Sprite2D: ", has_node("Sprite2D"))
	if has_node("Sprite2D"):
		var sprite = get_node("Sprite2D")
		print("Sprite texture: ", sprite.texture != null)
		print("Sprite visible: ", sprite.visible)

func _physics_process(delta):
	position.x -= speed * delta
	if position.x < remove_x:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		queue_free()
