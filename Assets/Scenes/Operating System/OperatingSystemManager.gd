extends Control

@onready var sigmantosh_menu = $SigmantoshMenu

func _on_exit_button_pressed() -> void:
	# hide the PC UI when the player exits it and also reset the values
	self.visible = false
	sigmantosh_menu.visible = false


func _on_sigmantosh_button_pressed() -> void:
	if not sigmantosh_menu.visible:
		sigmantosh_menu.visible = true
	else:
		sigmantosh_menu.visible = false
