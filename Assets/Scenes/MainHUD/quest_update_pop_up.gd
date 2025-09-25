extends Panel

var animation
@onready var label = $RichTextLabel

func _ready() -> void:
	animation = get_node_or_null("AnimationPlayer")

func show_popup(quest_objective_text):
	if animation == null:
		print("not there")
		return
	animation.stop()
	animation.play("quest_popup")
	label.text = quest_objective_text
