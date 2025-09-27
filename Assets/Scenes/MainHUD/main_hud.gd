extends Control

@onready var death_screen = $DeathScreen

func _ready() -> void:
	death_screen.visible = false

func _process(delta: float) -> void:
	if MainGameManager.rembo_dead:
		death_screen.visible = true
		get_tree().paused = true
