extends Control

@onready var mail_list: VBoxContainer = $Mails/VBoxContainer
@onready var mail_details_window = $MailDetails/MailDetailsWindow
@onready var mail_subject_detailed: RichTextLabel = $MailDetails/MailDetailsWindow/MailSubjectDetailed
@onready var mail_body_detailed: RichTextLabel = $MailDetails/MailDetailsWindow/MailBodyDetailed
@export var mail_item_scene: PackedScene

func _ready() -> void:
	mail_details_window.visible = false
	var file = FileAccess.open("res://Assets/Scenes/Operating System/Mail/mails.json", FileAccess.READ)
	if file == null:
		print("Failed to open mails.json")
		return

	var text = file.get_as_text()
	file.close()

	var mails = JSON.parse_string(text)
	if mails == null:
		print("Failed to parse mails.json")
		return

	for mail in mails:
		var item = mail_item_scene.instantiate()
		item.setup(mail)
		item.connect("mail_selected", Callable(self, "_on_mail_selected"))
		mail_list.add_child(item)

func _on_mail_selected(subject: String, body: String) -> void:
	mail_details_window.visible = true
	mail_subject_detailed.text = subject
	mail_body_detailed.text = body


func _on_mail_details_close_button_pressed() -> void:
	mail_details_window.visible = false


func _on_app_close_pressed() -> void:
	self.visible = false


func _on_app_maximize_pressed() -> void:
	if get_parent():
		self.size = get_parent().size
		self.position = Vector2.ZERO
