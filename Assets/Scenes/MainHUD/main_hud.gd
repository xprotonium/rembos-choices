extends Control

@onready var death_screen = $DeathScreen
@onready var win = $Panel

func _ready() -> void:
	win.visible = false
	death_screen.visible = false

func _process(delta: float) -> void:
	if MainGameManager.hunger == 0:
		death_screen.visible = true
		get_tree().paused = true
	if MainGameManager.you_win == true:
		win.visible = true
		get_tree().paused = true

func _on_respawn_button_pressed() -> void:
	get_tree().paused = false
	MainGameManager.rembo_dead = false
	death_screen.visible = false
	
	MainGameManager.load_game()
	
	if MainGameManager.player:
		MainGameManager.player.global_position = MainGameManager.player_position
	
	MainGameManager.emit_signal("stats_updated")
	MainGameManager.emit_signal("quest_stage_changed", MainGameManager.current_stage)
