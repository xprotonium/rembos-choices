extends Control

@onready var buttons = $PanelContainer/VBoxContainer.get_children()
@onready var selection_cursor_1 = $SelectionCursor
@onready var selection_cursor_2 = $SelectionCursor2
@onready var music = $"../AudioStreamPlayer"

var index = 0

func _ready() -> void:
	selection_cursor_1.global_position.y = buttons[index].global_position.y + 10
	selection_cursor_2.global_position.y = buttons[index].global_position.y + 10


func _process(delta: float) -> void:
	_traverse_buttons()


func _traverse_buttons():
	if Input.is_action_just_pressed("ui_down"):
		index += 1
	elif Input.is_action_just_pressed("ui_up"):
		index -= 1
	elif Input.is_action_just_pressed("ui_accept"):
		if index == 0:
			_on_play_pressed()
		else:
			_on_quit_pressed()
	
	index = (index + buttons.size()) % buttons.size()
	
	selection_cursor_1.global_position.y = buttons[index].global_position.y + 10
	selection_cursor_2.global_position.y = buttons[index].global_position.y + 10

func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/TMON/Scenes/TMON.tscn")


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")


func _on_audio_stream_player_finished() -> void:
	await get_tree().create_timer(4).timeout
	music.play()
