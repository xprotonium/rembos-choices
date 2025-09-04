extends Node2D

@export var obstacle_scene: PackedScene
@export var ability_scene: PackedScene
@export var spawn_interval: float = 2.0

var spawn_timer: Timer

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_timer_timeout)
	add_child(spawn_timer)

func _on_timer_timeout():
	var scene_to_spawn = obstacle_scene
	var scene_to_spawn2 = ability_scene
	var spawn_y = randf_range(0, -150)
	var spawn_x = randf_range(0, 950)
	
	var instance = scene_to_spawn.instantiate()
	instance.position = Vector2(spawn_x, spawn_y)
	get_parent().add_child(instance)
	
	var instance2 = scene_to_spawn2.instantiate()
	instance2.position = Vector2(spawn_x, spawn_y)
	get_parent().add_child(instance2)
