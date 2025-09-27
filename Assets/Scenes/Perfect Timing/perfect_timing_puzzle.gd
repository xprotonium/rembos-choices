extends Node2D

@onready var dialog_box = $"Dialog box"

func _ready() -> void:
	dialog_box.start_dialogue()
