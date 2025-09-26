extends Control

signal mail_selected(subject: String, body: String)

var subject: String
var body: String

func setup(data: Dictionary) -> void:
	subject = data.get("subject", "No Subject")
	body = data.get("body", "No Body")
	
	var subject_label = get_node("Panel/RichTextLabel") as RichTextLabel
	if subject_label:
		subject_label.text = subject

func _on_button_pressed() -> void:
	emit_signal("mail_selected", subject, body)
