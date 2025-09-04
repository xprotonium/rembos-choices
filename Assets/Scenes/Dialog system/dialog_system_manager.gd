extends Control

# variables for reading from json file
# Set this to the path of your own JSON file
var json_file = "res://Assets/Scenes/Dialog system/testing_file.json"
var json_as_text = FileAccess.get_file_as_string(json_file)
var json_as_dict = JSON.parse_string(json_as_text)

@onready var name_label = $MarginContainer/PanelContainer/MarginContainer/NameLabel
@onready var dialog_label = $MarginContainer/PanelContainer/MarginContainer/DialogLabel

# variables for the index counter
var current_index = -1

# player var
# to stop moving when in dialog
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	var player_scene = get_node(player_path)
	player = player_scene.get_node("CharacterBody2D") as CharacterBody2D

func _process(delta: float) -> void:
	if self.visible == true:
		player.allow_movement = false 
		
	if Input.is_action_just_pressed("fastforward"):
		current_index += 1
		if current_index < json_as_dict.size():
			name_label.text = json_as_dict[current_index]["name"]
			dialog_label.text = json_as_dict[current_index]["text"]
			dialog_label.visible_ratio = 0 #pain inducer 9000 (its a reset mechanism)
			
		else:
			# you can use your own final voiceline or speaker suit yourself
			name_label.text  = ""
			dialog_label.text = "All dialog finished!"
			
	# customize how fast you want the text to appear by changing value multiplied by delta
	if dialog_label.visible_ratio < 1:
		dialog_label.visible_ratio += 2.0 * delta
