extends Node2D

@export var obstacle_scene: PackedScene
@export var ability_scene: PackedScene
@export var spawn_interval: float = 2.0

var spawn_timer: Timer
var spawning_active = true
var game_time: float = 0.0
var current_spawn_interval: float = 2.0

func _ready():
	current_spawn_interval = spawn_interval
	spawn_timer = Timer.new()
	spawn_timer.wait_time = current_spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_timer_timeout)
	add_child(spawn_timer)
	print("Spawner started!")

func _process(delta):
	if not spawning_active:
		return
	
	game_time += delta
	current_spawn_interval = max(0.8, spawn_interval - (game_time * 0.02))
	spawn_timer.wait_time = current_spawn_interval

func _on_timer_timeout():
	if not spawning_active:
		return
	
	# SPAWN OBSTACLES
	if obstacle_scene:
		# First obstacle
		var obs1 = obstacle_scene.instantiate()
		obs1.position = Vector2(600, randf_range(-100, 0))  # ← KEEP ORIGINAL POSITION
		get_parent().add_child(obs1)
		
		# SLOWER speed increase over time
		if obs1.has_method("set_speed"):
			var base_speed = 500.0  # ← SLOWER START (250 instead of 300)
			var increased_speed = base_speed + (game_time * 10)  # ← SLOWER INCREASE (+5 instead of +10)
			obs1.set_speed(min(increased_speed, 900.0))  # ← LOWER MAX (450 instead of 600)
		
		# 40% CHANCE FOR SECOND OBSTACLE
		if randf() < 0.3:
			var obs2 = obstacle_scene.instantiate()
			obs2.position = Vector2(600, randf_range(-100, 0))  # ← KEEP ORIGINAL POSITION
			
			# MINIMUM 75 PIXEL GAP (was 50)
			while abs(obs2.position.y - obs1.position.y) < 75:  # ← CHANGED TO 75
				obs2.position.y = randf_range(-150, 0)
			
			get_parent().add_child(obs2)
			
			# SLOWER speed for second obstacle too
			if obs2.has_method("set_speed"):
				var base_speed = 500.0  # ← SLOWER START
				var increased_speed = base_speed + (game_time * 10)  # ← SLOWER INCREASE
				obs2.set_speed(min(increased_speed, 900.0))  # ← LOWER MAX
			
			print("DOUBLE OBSTACLES SPAWNED! Gap: ", abs(obs2.position.y - obs1.position.y))
	
	# SPAWN ABILITY (30% chance)
	if ability_scene and randf() < 0.3:
		var ability = ability_scene.instantiate()
		ability.position = Vector2(1000, randf_range(-80, 80))  # ← KEEP ORIGINAL POSITION
		get_parent().add_child(ability)

func stop_spawning():
	spawning_active = false
	if spawn_timer:
		spawn_timer.stop()
	print("Spawning stopped")
