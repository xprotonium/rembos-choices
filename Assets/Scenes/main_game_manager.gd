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

# QUEST PROGRESSION
func advance_stage():
	if current_stage < QuestStage.DONE:
		current_stage += 1
		emit_signal("quest_stage_changed", current_stage)

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
	if not pause_menu_quest_title or not pause_menu_quest_description:
		return

	# Convert stage to an integer index (signal may pass int/Variant)
	var stage_index: int = int(stage)
	var stage_names: Array = QuestStage.keys()
	# bounds safety
	if stage_index < 0 or stage_index >= stage_names.size():
		pause_menu_quest_title.text = "Unknown Quest"
		pause_menu_quest_description.text = ""
		return

	# Explicitly cast to String
	var stage_name: String = String(stage_names[stage_index])

	if quest_details.has(stage_name) and typeof(quest_details[stage_name]) == TYPE_DICTIONARY:
		var q: Dictionary = quest_details[stage_name]
		pause_menu_quest_title.text = q.get("title", "")
		pause_menu_quest_description.text = q.get("description", "")
	else:
		pause_menu_quest_title.text = "Unknown Quest"
		pause_menu_quest_description.text = ""
