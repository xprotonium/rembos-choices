extends Panel

# Console
@onready var console_history = $History
@onready var console_input = $Input

func _ready():
	self.visible = false
	console_input.text_submitted.connect(_on_input_text_submitted)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("console"):
		self.visible = !self.visible
		if self.visible:
			console_input.grab_focus()

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.strip_edges() == "":
		return
		
	console_history.append_text("\n> " + new_text)
	run_command(new_text)
	console_input.text = ""

func run_command(cmd: String) -> void:
	var parts = cmd.strip_edges().split(" ")
	match parts[0]:
		"die":
			MainGameManager.rembo_dead = true
			console_history.append_text("\nRembo marked as dead.")
		"heal":
			MainGameManager.rembo_dead = false
			console_history.append_text("\nRembo healed (rembo_dead = false).")
		"dmg":
			# Since there’s no hp/take_dmg, just mark rembo_dead
			if parts.size() > 1 and int(parts[1]) > 0:
				MainGameManager.rembo_dead = true
				console_history.append_text("\nRembo took " + parts[1] + " damage and died.")
			else:
				console_history.append_text("\nUsage: dmg <amount>")
		"set_speed":
			if MainGameManager.player:
				if parts.size() > 1:
					if parts[1] == "default":
						MainGameManager.player.speed = 50
						console_history.append_text("\nPlayer speed reset to default (50).")
					else:
						MainGameManager.player.speed = float(parts[1])
						console_history.append_text("\nPlayer speed set to " + str(MainGameManager.player.speed))
				else:
					console_history.append_text("\nUsage: set_speed <value|default>")
			else:
				console_history.append_text("\nNo player found.")
		"set_jump":
			if MainGameManager.player:
				if parts.size() > 1:
					if parts[1] == "default":
						MainGameManager.player.jump_force = 150
						console_history.append_text("\nJump force reset to default (150).")
					else:
						MainGameManager.player.jump_force = float(parts[1])
						console_history.append_text("\nJump force set to " + str(MainGameManager.player.jump_force))
				else:
					console_history.append_text("\nUsage: set_jump <value|default>")
			else:
				console_history.append_text("\nNo player found.")
		"set_energy":
			if parts.size() > 1:
				var val = int(parts[1])
				MainGameManager.energy = clamp(val, 0, MainGameManager.max_energy)
				MainGameManager.emit_signal("stats_updated")
				console_history.append_text("\nEnergy set to " + str(MainGameManager.energy))
			else:
				console_history.append_text("\nUsage: set_energy <value>")
		"set_hunger":
			if parts.size() > 1:
				var val = int(parts[1])
				MainGameManager.hunger = clamp(val, 0, MainGameManager.max_hunger)
				MainGameManager.emit_signal("stats_updated")
				console_history.append_text("\nHunger set to " + str(MainGameManager.hunger))
			else:
				console_history.append_text("\nUsage: set_hunger <value>")
		"help":
			console_history.append_text("\nAvailable commands:")
			console_history.append_text("\n  die - Mark Rembo as dead")
			console_history.append_text("\n  heal - Mark Rembo as alive")
			console_history.append_text("\n  dmg <amount> - Deal damage (marks Rembo as dead)")
			console_history.append_text("\n  set_speed <value|default> - Change or reset player speed")
			console_history.append_text("\n  set_jump <value|default> - Change or reset jump force")
			console_history.append_text("\n  set_energy <value> - Set energy within range")
			console_history.append_text("\n  set_hunger <value> - Set hunger within range")
			console_history.append_text("\n  help - Show this list of commands")
		_:
			console_history.append_text("\nUnknown command: " + cmd)
