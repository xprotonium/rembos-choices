extends Node

var energy: int = 10
var max_energy: int = 10
var hunger: int = 0
var max_hunger: int = 10
var is_sleeping: bool = false
var is_dead: bool = false

var energy_timer: Timer
var hunger_timer: Timer

var energy_label: Label
var hunger_label: Label
var status_label: Label

func _ready():
	create_ui()
	
	setup_timers()
	
	print("Player Stats System Started!")
	print("Energy: ", energy, "/", max_energy)
	print("Hunger: ", hunger, "/", max_hunger)

func create_ui():
	energy_label = Label.new()
	energy_label.text = "ENERGY: " + str(energy) + "/" + str(max_energy)
	energy_label.add_theme_font_size_override("font_size", 24)
	energy_label.add_theme_color_override("font_color", Color.BLUE)
	energy_label.position = Vector2(20, 20)
	add_child(energy_label)
	
	hunger_label = Label.new()
	hunger_label.text = "HUNGER: " + str(hunger) + "/" + str(max_hunger)
	hunger_label.add_theme_font_size_override("font_size", 24)
	hunger_label.add_theme_color_override("font_color", Color.ORANGE)
	hunger_label.position = Vector2(20, 60)
	add_child(hunger_label)
	
	status_label = Label.new()
	status_label.text = "STATUS: AWAKE"
	status_label.add_theme_font_size_override("font_size", 24)
	status_label.add_theme_color_override("font_color", Color.GREEN)
	status_label.position = Vector2(20, 100)
	add_child(status_label)
	
	var instructions = Label.new()
	instructions.text = "CONTROLS:\nSPACE - Sleep/Rest\nE - Eat Food\nR - Restart"
	instructions.add_theme_font_size_override("font_size", 16)
	instructions.position = Vector2(20, 150)
	add_child(instructions)

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

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"): 
		toggle_sleep()
	
	if Input.is_action_just_pressed("ui_select"): 
		eat_food()
	
	if Input.is_action_just_pressed("ui_cancel"): 
		restart_game()
	
	update_ui()

func _on_energy_timer_timeout():
	if is_sleeping:
		return 
	
	if is_dead:
		return 
	
	energy = max(0, energy - 2)
	print("Energy decreased: ", energy, "/", max_energy)
	
	if energy <= 0:
		die()

func _on_hunger_timer_timeout():
	if is_dead:
		return 
	
	hunger = min(max_hunger, hunger + 1)
	print("Hunger increased: ", hunger, "/", max_hunger)

func toggle_sleep():
	if is_dead:
		return
	
	is_sleeping = !is_sleeping
	
	if is_sleeping:
		energy = max_energy
		status_label.text = "STATUS: SLEEPING"
		status_label.add_theme_color_override("font_color", Color.PURPLE)
		print("Went to sleep - Energy restored!")
	else:
		status_label.text = "STATUS: AWAKE"
		status_label.add_theme_color_override("font_color", Color.GREEN)
		print("Woke up!")

func eat_food():
	if is_dead:
		return
	
	if hunger > 0:
		hunger = max(0, hunger - 2) 
		print("Ate food! Hunger: ", hunger, "/", max_hunger)
	else:
		print("Not hungry!")

func die():
	is_dead = true
	status_label.text = "STATUS: DEAD"
	status_label.add_theme_color_override("font_color", Color.RED)
	print("Player died! Press R to restart")

func restart_game():
	energy = max_energy
	hunger = 0
	is_sleeping = false
	is_dead = false
	
	energy_timer.start()
	hunger_timer.start()
	
	status_label.text = "STATUS: AWAKE"
	status_label.add_theme_color_override("font_color", Color.GREEN)
	
	print("Game restarted!")

func update_ui():
	if is_dead:
		return
	
	energy_label.text = "ENERGY: " + str(energy) + "/" + str(max_energy)
	hunger_label.text = "HUNGER: " + str(hunger) + "/" + str(max_hunger)
	
	if energy <= 3:
		energy_label.add_theme_color_override("font_color", Color.RED)
	elif energy <= 6:
		energy_label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		energy_label.add_theme_color_override("font_color", Color.BLUE)
	
	if hunger >= 8:
		hunger_label.add_theme_color_override("font_color", Color.RED)
	elif hunger >= 5:
		hunger_label.add_theme_color_override("font_color", Color.YELLOW)
	else:
		hunger_label.add_theme_color_override("font_color", Color.ORANGE)
