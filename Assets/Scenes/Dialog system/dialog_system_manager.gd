extends Control

# variables for reading from json file
# Set this to the path of your own JSON file
var json_file = "res://Assets/Scenes/Dialog system/testing_file.json"
var json_as_text = FileAccess.get_file_as_string(json_file)
var json_as_dict = JSON.parse_string(json_as_text)

# variables for the index counter
var current_index = -1


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fastforward"):
		current_index += 1
		if current_index < json_as_dict.size():
			$MarginContainer/PanelContainer/MarginContainer/NameLabel.text = json_as_dict[current_index]["name"]
			$MarginContainer/PanelContainer/MarginContainer/DialogLabel.text = json_as_dict[current_index]["text"]
			$MarginContainer/PanelContainer/MarginContainer/DialogLabel.visible_ratio = 0 #pain inducer 9000 (its a reset mechanism)
			
		else:
			# you can use your own final voiceline or speaker suit yourself
			$MarginContainer/PanelContainer/MarginContainer/NameLabel.text  = ""
			$MarginContainer/PanelContainer/MarginContainer/DialogLabel.text = "All dialog finished!"
			
	# customize how fast you want the text to appear by changing value multiplied by delta
	if $MarginContainer/PanelContainer/MarginContainer/DialogLabel.visible_ratio < 1:
		$MarginContainer/PanelContainer/MarginContainer/DialogLabel.visible_ratio += 2.0 * delta
