extends CanvasLayer

@onready var energy_bar = $MainHud/PlayerStats/Energy
@onready var hunger_bar = $MainHud/PlayerStats/Hunger
@onready var pause_menu_quest_title: RichTextLabel = $MainHud/PauseMenu/PauseMenuRightPanel/QuestTitle
@onready var pause_menu_quest_description: RichTextLabel = $MainHud/PauseMenu/PauseMenuRightPanel/QuestDescription

func _ready() -> void:
	MainGameManager.hunger_bar = hunger_bar
	MainGameManager.energy_bar = energy_bar
	MainGameManager.setup_ui(hunger_bar, energy_bar)
	
	MainGameManager.pause_menu_quest_title = pause_menu_quest_title
	MainGameManager.pause_menu_quest_description = pause_menu_quest_description
	MainGameManager.update_quest_ui(MainGameManager.current_stage)
