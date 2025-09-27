extends Control

@onready var sigmantosh_menu = $SigmantoshMenu
@onready var mail_app = $MailApp
@onready var tmon: Button = $MarginContainer2/Panel/BoxContainer/TMON
@onready var C57: Button = $MarginContainer2/Panel/BoxContainer/C57
@onready var perfect_timing: Button = $"MarginContainer2/Panel/BoxContainer/Perfect Timing"

# since the player is an instanced node, we need the node path
# then use it as root node
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	
	# we use the path to get the root node
	# then get the characterbody2d in which the script is stored in
	# i wonder what happens if i move the script to the main node itself lmao
	var player_scene = get_node(player_path)
	player = player_scene.get_node("CharacterBody2D") as CharacterBody2D
	
	MainGameManager.quest_stage_changed.connect(update_ui)
	
	# set the button state depending on the quest progression
	update_ui()

func _process(_delta: float) -> void:
	if self.visible:
		player.allow_movement = false
	
	update_ui()

func _on_exit_button_pressed() -> void:
	# hide the PC UI when the player exits it and also reset the values
	self.visible = false
	sigmantosh_menu.visible = false
	player.allow_movement = true


func _on_sigmantosh_button_pressed() -> void:
	# bring up the ui when proximity button is pressed
	if not sigmantosh_menu.visible:
		sigmantosh_menu.visible = true
	else:
		sigmantosh_menu.visible = false
	
	update_ui()


func _on_tmon_pressed() -> void:
	MainGameManager.player_position = player.global_position
	get_tree().change_scene_to_file("res://Assets/Scenes/TMON/Scenes/TMONMainMenu.tscn")


func _on_c_57_pressed() -> void:
	MainGameManager.player_position = player.global_position
	get_tree().change_scene_to_file("res://Assets/Scenes/minigame2/Minigame2.tscn")


func _on_perfect_timing_pressed() -> void:
	MainGameManager.player_position = player.global_position
	get_tree().change_scene_to_file("res://Assets/Scenes/Perfect Timing/PTMainMenu.tscn")


func _on_mail_pressed() -> void:
	if MainGameManager.current_stage == MainGameManager.QuestStage.OPEN_MAIL_APP:
		MainGameManager.advance_stage()
		MainGameManager.update_quest_ui(MainGameManager.current_stage)
	mail_app.visible = true


func update_ui(_new_stage = null):
	if tmon:
		tmon.disabled = MainGameManager.current_stage < MainGameManager.QuestStage.PLAY_RPG

	if C57:
		C57.disabled = MainGameManager.current_stage < MainGameManager.QuestStage.PLAY_C57

	if perfect_timing:
		perfect_timing.disabled = MainGameManager.current_stage < MainGameManager.QuestStage.PLAY_PERFECT_TIMING
