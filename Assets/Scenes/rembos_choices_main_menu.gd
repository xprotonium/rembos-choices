extends Control

@onready var NewGameButton = $Panel/HBoxContainer/NewGameButton
@onready var LoadGameButton = $Panel/HBoxContainer/LoadGameButton
@onready var QuitGameButton = $Panel/HBoxContainer/QuitButton
@onready var DeleteSaveButton = $Panel/DeleteSaveButton

func _ready() -> void:
	_update_load_delete_buttons()

func _on_new_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")

func _on_load_game_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
	call_deferred("_do_load_game")

func _do_load_game() -> void:
	if MainGameManager:
		MainGameManager.load_game()
		print("Loaded game from menu")
	else:
		print("MainGameManager singleton not found!")

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_delete_save_button_pressed() -> void:
	var save_path = "user://savegame.json"
	if FileAccess.file_exists(save_path):
		var err = DirAccess.remove_absolute(save_path)
		if err == OK:
			print("Save file deleted successfully")
		else:
			print("Failed to delete save file, error:", err)
	_update_load_delete_buttons()

func _update_load_delete_buttons() -> void:
	var save_exists = FileAccess.file_exists("user://savegame.json")
	LoadGameButton.visible = save_exists
	LoadGameButton.disabled = not save_exists
	DeleteSaveButton.visible = save_exists
	DeleteSaveButton.disabled = not save_exists
