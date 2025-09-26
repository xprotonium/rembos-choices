extends Control

func _ready() -> void:
	self.visible = false

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
	get_tree().quit()
