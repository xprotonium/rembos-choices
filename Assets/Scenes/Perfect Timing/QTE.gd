extends Container

@export var button : TextureRect

@export var button_ani_player : AnimationPlayer
func _ready() -> void:
	button_ani_player.play("QTE")
