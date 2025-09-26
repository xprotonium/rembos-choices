extends CanvasLayer

# HP BAR
@onready var hp_bar = $"Control/HPBar/MarginCounter/TextureProgressBar"
@onready var hp_text = $Control/HPBar/MarginCounter/Label

# PICK UP UI
@onready var pickup_ui = $Control/PickUpInfo
@onready var item_sprite = $Control/PickUpInfo/HBoxContainer/TextureRect
@onready var item_description = $Control/PickUpInfo/HBoxContainer/Label
@export var pickup_sound: AudioStreamPlayer

# DEATH SCREEN
@onready var death_screen = $Control/DeathScreen
@onready var death_screen_text = $Control/DeathScreen/Label
@onready var respawn_button = $Control/DeathScreen/HBoxContainer/RespawnButton
@onready var quit_button = $Control/DeathScreen/HBoxContainer/QuitButton

# Console
@onready var console = $Control/Console
@onready var console_history = $Control/Console/History
@onready var console_input = $Control/Console/Input

# get the player hp
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	player = get_node(player_path)
	hp_bar.max_value = player.max_hp
	hp_bar.value = player.hp
	hp_text.text = str(player.hp)
	pickup_ui.visible = false
	death_screen.visible = false
	console.visible = false
	self.visible = true
	console_input.focus_entered.connect(_on_focus_entered)
	console_input.focus_exited.connect(_on_focus_exited)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("console"):
		console.visible = !console.visible
		if console.visible:
			console_input.grab_focus()

func _show_pickup_info(texture: Texture2D, description: String):
	get_tree().paused = true
	pickup_sound.play()
	pickup_ui.visible = true
	item_sprite.texture = texture
	item_description.text = description

func _on_button_pressed() -> void:
	pickup_ui.visible = false
	get_tree().paused = false


func _show_death_screen():
	death_screen.visible = true


func _on_respawn_button_pressed() -> void:
	get_tree().paused = false
	print("player died!")
	get_tree().reload_current_scene()



func _on_quit_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")


func _on_input_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == "":
		return
		
	console_history.append_text("\n> " + new_text)
	
	run_command(new_text)
	
	console_input.text = ""

func _on_focus_entered():
	GameManager.console_open = true

func _on_focus_exited():
	GameManager.console_open = false

func run_command(cmd: String) -> void:
	var parts = cmd.strip_edges().split(" ")
	match parts[0]:
		"die":
			GameManager.player.take_dmg(GameManager.player.hp)
			console_history.append_text("\nPlayer killed instantly.")
		"heal":
			GameManager.player.hp = GameManager.player.max_hp
			hp_bar.value = GameManager.player.max_hp
			hp_text.text = str(GameManager.player.hp)
			console_history.append_text("\nHealed to full.")
		"dmg":
			var dmg_value := 10  # default if no number given
			if parts.size() > 1:
				var num = int(parts[1])
				dmg_value = clamp(num, 0, GameManager.player.max_hp)
			
			if dmg_value > 0:
				GameManager.player.take_dmg(dmg_value)
				console_history.append_text("\nDealt " + str(dmg_value) + " damage to player")
			else:
				console_history.append_text("\nInvalid damage amount")
		"set_speed":
			if parts.size() > 1:
				if parts[1] == "default":
					GameManager.player.speed = 50
					console_history.append_text("\nPlayer speed reset to default (50).")
				else:
					GameManager.player.speed = float(parts[1])
					console_history.append_text("\nPlayer speed set to " + str(GameManager.player.speed))
			else:
				console_history.append_text("\nUsage: set_speed <value|default>")
		"set_jump":
			if parts.size() > 1:
				if parts[1] == "default":
					GameManager.player.jump_force = 150
					console_history.append_text("\nJump force reset to default (150).")
				else:
					GameManager.player.jump_force = float(parts[1])
					console_history.append_text("\nJump force set to " + str(GameManager.player.jump_force))
			else:
				console_history.append_text("\nUsage: set_jump <value|default>")
		"test_energy":
			print(MainGameManager.energy)
			MainGameManager.energy = 3
			print(MainGameManager.energy)
		"help":
			console_history.append_text("\nAvailable commands:")
			console_history.append_text("\n  die - Kill the player instantly")
			console_history.append_text("\n  heal - Restore player to full health")
			console_history.append_text("\n  dmg <amount> - Deal damage to the player (default 10)")
			console_history.append_text("\n  set_speed <value|default> - Change or reset player speed")
			console_history.append_text("\n  set_jump <value|default> - Change or reset jump force")
			console_history.append_text(("\n test_hunger: set the hunger to lower than 5"))
			console_history.append_text("\n  help - Show this list of commands")
		_:
			console_history.append_text("\nUnknown command: " + cmd)
