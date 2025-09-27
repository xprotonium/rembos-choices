extends Control

@onready var death_screen = $DeathScreen
@onready var win = $Panel

func _ready() -> void:
	win.visible = false
	death_screen.visible = false

func _process(delta: float) -> void:
	if MainGameManager.rembo_dead:
		death_screen.visible = true
		get_tree().paused = true
	if MainGameManager.you_win == true:
		win.visible = true
		get_tree().paused
