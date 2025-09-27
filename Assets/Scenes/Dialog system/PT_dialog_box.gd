extends Control

var json_file = "res://Assets/Scenes/Dialog system/testing_file.json"
var json_as_text = FileAccess.get_file_as_string(json_file)
var json_as_dict = JSON.parse_string(json_as_text)

@onready var name_label = $MarginContainer/PanelContainer/MarginContainer/NameLabel
@onready var dialog_label = $MarginContainer/PanelContainer/MarginContainer/DialogLabel

var current_index = -1
@onready var player: Node = $"../Player"

func _ready() -> void:
	print("DialogBox ready. Loaded JSON file:", json_file)
	if json_as_dict == null or not (json_as_dict is Array):
		push_error("JSON file is invalid or not an array.")
		json_as_dict = []
	else:
		print("JSON loaded successfully with", json_as_dict.size(), "entries.")
	self.visible = true

func start_dialogue():
	print("start_dialogue() called")
	self.visible = true
	current_index = -1
	if player:
		player.allow_movement = false
	else:
		print("WARNING: Player not found!")
	_advance_dialogue()

func _process(delta: float) -> void:
	if self.visible == true:
		if Input.is_action_just_pressed("interact"):
			print("Interact pressed at index:", current_index)
			if dialog_label.visible_ratio < 1.0:
				dialog_label.visible_ratio = 1.0
				print("Skipped typewriter effect")
			else:
				_advance_dialogue()

	if dialog_label.visible_ratio < 1.0:
		dialog_label.visible_ratio = min(dialog_label.visible_ratio + 2.0 * delta, 1.0)

func _advance_dialogue():
	current_index += 1
	print("Advancing dialogue. Current index:", current_index)
	if current_index < json_as_dict.size():
		name_label.text = json_as_dict[current_index]["name"]
		dialog_label.text = json_as_dict[current_index]["text"]
		dialog_label.visible_ratio = 0
		print("Showing line:", name_label.text, ":", dialog_label.text)
	elif current_index == json_as_dict.size():
		name_label.text = ""
		dialog_label.text = "All dialog finished!"
		if player:
			player.allow_movement = true
		print("Dialogue finished")
	else:
		if player:
			player.allow_movement = true
		self.visible = false
		current_index = -1
		print("Dialogue box hidden, reset index")
