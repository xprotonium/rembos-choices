extends Control

@onready var sigmantosh_menu = $SigmantoshMenu
@onready var mail_app = $MailApp
@onready var tmon = $MarginContainer2/Panel/BoxContainer/TMON
@onready var C57 = $MarginContainer2/Panel/BoxContainer/C57
@onready var perfect_timing = $"MarginContainer2/Panel/BoxContainer/Perfect Timing"

# since the player is an instanced node, we need the node path
# then use it as root node
@export var player_path: NodePath
var player: CharacterBody2D

# game manager to lock the minigames unless the player is at
# a certain level of game progress
@export var game_manager: Node

func _ready() -> void:
	# we use the path to get the root node
	# then get the characterbody2d in which the script is stored in
	# i wonder what happens if i move the script to the main node itself lmao
	var player_scene = get_node(player_path)
	player = player_scene.get_node("CharacterBody2D") as CharacterBody2D
	
	game_manager.quest_stage_changed.connect(update_ui)
	
	# set the button state depending on the quest progression
	update_ui()

func _process(delta: float) -> void:
	if self.visible:
		player.allow_movement = false

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


func _on_tmon_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/TMON/Scenes/TMONMainMenu.tscn")


func _on_c_57_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/minigame2/Minigame2.tscn")


func _on_perfect_timing_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Perfect Timing/perfect_timing.tscn")


func _on_mail_pressed() -> void:
	mail_app.visible = true


func update_ui(_new_stage = null):
	if game_manager.current_stage >= game_manager.QuestStage.PLAY_RPG:
		tmon.disabled = false
	else:
		tmon.disabled = true
	
	if game_manager.current_stage >= game_manager.QuestStage.PLAY_C57:
		C57.disabled = false
	else:
		C57.disabled = true
		
	if game_manager.current_stage >= game_manager.QuestStage.PLAY_PERFECT_TIMING:
		perfect_timing.disabled = false
	else:
		perfect_timing.disabled = true
