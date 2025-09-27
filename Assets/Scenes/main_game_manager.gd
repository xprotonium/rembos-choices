extends Node

# Quest System
enum QuestStage {
	INTRO,
	GO_TO_LAPTOP,
	OPEN_MAIL_APP,
	PLAY_RPG,
	PLAY_C57,
	PLAY_PERFECT_TIMING,
	DONE
}

var current_stage: QuestStage = QuestStage.INTRO
signal quest_stage_changed(new_stage)

# Quest data loaded from JSON
var quest_details: Dictionary = {}

# Player Stats
var player: CharacterBody2D = null
var player_position: Vector2 = Vector2.ZERO

var energy: int = 10
var max_energy: int = 10
var hunger: int = 10
var max_hunger: int = 10

var gold = 0

var energy_timer: Timer
var hunger_timer: Timer

signal stats_updated

var energy_bar: TextureProgressBar
var hunger_bar: TextureProgressBar

# Pause Menu Quest Details
var pause_menu_quest_title: RichTextLabel
var pause_menu_quest_description: RichTextLabel

# intro cutscene played or not
var intro_played = false

func _ready():
	var quest_detail_file = FileAccess.open("res://Assets/Scenes/quest_details.json", FileAccess.READ)
	if quest_detail_file == null:
		print("Cannot open quest detail json")
		return
	
	var quest_text = quest_detail_file.get_as_text()
	quest_detail_file.close()
	
	var parsed = JSON.parse_string(quest_text)
	if parsed == null:
		print("Failed to parse quest detail json")
		return
	quest_details = parsed

	setup_timers()

	if not stats_updated.is_connected(update_stats_ui):
		stats_updated.connect(update_stats_ui)
	if not quest_stage_changed.is_connected(update_quest_ui):
		quest_stage_changed.connect(update_quest_ui)

	call_deferred("update_stats_ui")
	call_deferred("_deferred_update_quest_ui")
	
	if intro_played:
		$AnimationPlayer.stop()
		$AnimationPlayer.playback_active = false 
		player.global_position = player_position


func _deferred_update_quest_ui() -> void:
	update_quest_ui(current_stage)

func set_player(p: CharacterBody2D) -> void:
	player = p
	if player and player_position != Vector2.ZERO:
		player.global_position = player_position
		print("MainGameManager: restored player position to ", player_position)

	if not intro_played:
		call_deferred("play_intro_cutscene")


# IMPORTANT: Call this before changing scenes to save current player position!
func save_player_position() -> void:
	if player:
		player_position = player.global_position
		print("MainGameManager: saved player position ", player_position)
	else:
		print("MainGameManager: save_player_position called but player is null")

func advance_stage():
	if current_stage < QuestStage.DONE:
		print("Advancing stage from", current_stage)
		current_stage += 1
		emit_signal("quest_stage_changed", current_stage)
		update_quest_ui(current_stage)

func setup_timers():
	energy_timer = Timer.new()
	energy_timer.wait_time = 60.0
	energy_timer.one_shot = false
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	add_child(energy_timer)
	energy_timer.start()
	
	hunger_timer = Timer.new()
	hunger_timer.wait_time = 30.0
	hunger_timer.one_shot = false
	hunger_timer.timeout.connect(_on_hunger_timer_timeout)
	add_child(hunger_timer)
	hunger_timer.start()

func _on_energy_timer_timeout():
	energy = max(0, energy - 2)
	emit_signal("stats_updated")

func _on_hunger_timer_timeout():
	hunger = min(max_hunger, hunger - 1)
	emit_signal("stats_updated")

func sleep():
	energy = max_energy
	emit_signal("stats_updated")

func eat_food():
	if hunger > 0:
		hunger = max(0, hunger - 2)
		emit_signal("stats_updated")

func restart_game():
	energy = max_energy
	hunger = 0
	energy_timer.start()
	hunger_timer.start()
	emit_signal("stats_updated")

func update_stats_ui():
	if not energy_bar or not hunger_bar:
		return

	energy_bar.max_value = max_energy
	energy_bar.value = energy
	
	hunger_bar.max_value = max_hunger
	hunger_bar.value = hunger
	print("MainGameManager: hunger =", hunger)

func setup_ui(hunger: TextureProgressBar, energy: TextureProgressBar) -> void:
	hunger_bar = hunger
	energy_bar = energy
	update_stats_ui()

func update_quest_ui(stage) -> void:
	var scene_root = get_tree().current_scene
	if not scene_root:
		return

	var pause_menu = scene_root.get_node_or_null("CanvasLayer/MainHud/PauseMenu")
	if not pause_menu:
		return

	var title: RichTextLabel = pause_menu.get_node_or_null("PauseMenuRightPanel/QuestTitle")
	var desc: RichTextLabel = pause_menu.get_node_or_null("PauseMenuRightPanel/QuestDescription")
	if not title or not desc:
		print("QuestTitle or QuestDescription not found under PauseMenu")
		return

	# Convert stage to an integer index
	var stage_index: int = int(stage)
	var stage_names: Array = QuestStage.keys()

	if stage_index < 0 or stage_index >= stage_names.size():
		title.text = "Unknown Quest"
		desc.text = ""
		return

	var stage_name: String = String(stage_names[stage_index])
	if quest_details.has(stage_name) and typeof(quest_details[stage_name]) == TYPE_DICTIONARY:
		var q: Dictionary = quest_details[stage_name]
		title.text = q.get("title", "")
		desc.text = q.get("description", "")
		print("Updated quest UI ->", q)
	else:
		title.text = "Unknown Quest"
		desc.text = ""

	if stage_index > 0:
		var main_hud = scene_root.get_node_or_null("CanvasLayer/MainHud")
		if main_hud:
			var quest_popup = main_hud.get_node_or_null("QuestPopUp")
			if quest_popup and quest_details.has(stage_name):
				var q: Dictionary = quest_details[stage_name]
				if quest_popup.has_method("show_popup"):
					quest_popup.show_popup(q.get("objective", ""))

func play_intro_cutscene():
	var scene_root = get_tree().current_scene

	if player:
		player.set_allow_movement(false)

	if scene_root and scene_root.has_node("AnimationPlayer"):
		var anim_player: AnimationPlayer = scene_root.get_node("AnimationPlayer")
		
		var callback: Callable = Callable(self, "_on_intro_animation_finished")
		if not anim_player.animation_finished.is_connected(callback):
			anim_player.animation_finished.connect(callback)
		
		anim_player.play("intro")
		intro_played = true


func _on_intro_animation_finished(anim_name: String) -> void:
	if anim_name != "intro":
		return
	player.set_allow_movement(true)
	advance_stage()

func save_game() -> void:
	var save_data := {
		"current_stage": current_stage,
		"player_position": [player_position.x, player_position.y],
		"energy": energy,
		"hunger": hunger,
		"gold": gold,  # <--- save gold too
		"intro_played": intro_played
	}

	var file := FileAccess.open("user://savegame.json", FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("Game saved:", save_data)

func load_game() -> void:
	print("--- Attempting to load game ---")

	if not FileAccess.file_exists("user://savegame.json"):
		print("No save file found at user://savegame.json")
		return

	var file := FileAccess.open("user://savegame.json", FileAccess.READ)
	if not file:
		print("Failed to open save file")
		return

	var text := file.get_as_text()
	file.close()
	print("Save file loaded, parsing JSON...")

	var data = JSON.parse_string(text)
	if typeof(data) != TYPE_DICTIONARY:
		print("Invalid save data, expected Dictionary but got:", typeof(data))
		return

	current_stage = data.get("current_stage", QuestStage.INTRO)
	print("Restored current_stage:", current_stage)

	var pos_data = data.get("player_position", null)
	if pos_data and typeof(pos_data) == TYPE_ARRAY and pos_data.size() == 2:
		player_position = Vector2(pos_data[0], pos_data[1])
	else:
		player_position = Vector2.ZERO
	print("Restored player_position:", player_position)

	energy = data.get("energy", max_energy)
	print("Restored energy:", energy)

	hunger = data.get("hunger", max_hunger)
	print("Restored hunger:", hunger)

	gold = data.get("gold", 0)
	print("Restored gold:", gold)

	intro_played = data.get("intro_played", false)
	print("Restored intro_played:", intro_played)

	emit_signal("stats_updated")
	emit_signal("quest_stage_changed", current_stage)

	if player:
		player.global_position = player_position
		print("Player position set to", player_position)
