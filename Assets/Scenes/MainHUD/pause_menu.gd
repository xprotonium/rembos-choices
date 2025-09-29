extends Control

@onready var save_game_toast = $"../SaveGameToast"

func _ready() -> void:
	self.visible = false
	save_game_toast.visible = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not self.visible:
			self.visible = true
			get_tree().paused = true
		else:
			self.visible = false
			get_tree().paused = false


func _on_resume_button_pressed() -> void:
	self.visible = false
	get_tree().paused = false


func _on_quit_button_pressed() -> void:
	MainGameManager.save_player_position()
	MainGameManager.save_game()
	get_tree().quit()


func _on_save_game_button_pressed() -> void:
	MainGameManager.save_player_position()
	MainGameManager.save_game()
	save_game_toast.visible = true
	await get_tree().create_timer(3).timeout
	save_game_toast.visible = false
