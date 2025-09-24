extends Node

# QUEST SYSTEM
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

# PLAYER STATS
@export var player: CharacterBody2D
var energy: int = 10
var max_energy: int = 10
var hunger: int = 10
var max_hunger: int = 10

var energy_timer: Timer
var hunger_timer: Timer

signal stats_updated

@export var energy_bar: TextureProgressBar
@export var hunger_bar: TextureProgressBar

# Pause Menu Quest Details
@export var pause_menu_quest_title: RichTextLabel
@export var pause_menu_quest_description: RichTextLabel

# LIFECYCLE
func _ready():
	# Load quest details JSON
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
	
	# Setup systems
	setup_timers()
	stats_updated.connect(update_stats_ui)
	quest_stage_changed.connect(update_quest_ui)

	# Initial UI
	update_stats_ui()
	update_quest_ui(current_stage)
	
	play_intro_cutscene()

# QUEST PROGRESSION
func advance_stage():
	if current_stage < QuestStage.DONE:
		current_stage += 1
		emit_signal("quest_stage_changed", current_stage)
		update_quest_ui(current_stage)

# TIMERS
func setup_timers():
	energy_timer = Timer.new()
	energy_timer.wait_time = 60.0
	energy_timer.timeout.connect(_on_energy_timer_timeout)
	add_child(energy_timer)
	energy_timer.start()
	
	hunger_timer = Timer.new()
	hunger_timer.wait_time = 30.0
	hunger_timer.timeout.connect(_on_hunger_timer_timeout)
	add_child(hunger_timer)
	hunger_timer.start()

func _on_energy_timer_timeout():
	energy = max(0, energy - 2)
	emit_signal("stats_updated")

func _on_hunger_timer_timeout():
	hunger = min(max_hunger, hunger - 1)
	emit_signal("stats_updated")

# STATS FUNCTIONS
func sleep():
	# restores energy to full
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

# UI UPDATE
func update_stats_ui():
	if not energy_bar or not hunger_bar:
		return

	energy_bar.max_value = max_energy
	energy_bar.value = energy
	
	hunger_bar.max_value = max_hunger
	hunger_bar.value = hunger

# Fixed update_quest_ui: explicit typing for 'q'
func update_quest_ui(stage) -> void:
	var scene_root = get_tree().current_scene
	if not scene_root:
		return

	# Find pause menu dynamically
	var pause_menu = scene_root.get_node_or_null("CanvasLayer/MainHud/PauseMenu")
	if not pause_menu:
		print("Pause menu not found in current scene")
		return

	# Now look inside pause_menu RELATIVE to it
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


# CUTSCENES
func play_intro_cutscene():
	var scene_root = get_tree().current_scene

	# Disable player movement if available
	if player:
		player.allow_movement = false

	if scene_root and scene_root.has_node("AnimationPlayer"):
		var anim_player: AnimationPlayer = scene_root.get_node("AnimationPlayer")
		anim_player.play("intro")

		# Re-enable movement and advance quest stage when cutscene finishes
		anim_player.animation_finished.connect(
			func(anim_name):
				if anim_name == "intro":
					if player:
						player.allow_movement = true
					advance_stage()
		)
	else:
		print("No AnimationPlayer found in current scene!")
		if player:
			player.allow_movement = true
