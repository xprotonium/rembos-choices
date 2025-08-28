extends Node2D

@export var obstacle_scene: PackedScene
@export var spawn_interval: float = 2.0

func _ready():
	var timer = Timer.new()
	timer.wait_time = spawn_interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout)
	add_child(timer)

func _on_timer_timeout():
	if obstacle_scene:
		var obs = obstacle_scene.instantiate()
		obs.position = Vector2(800, randf_range(100, 400))
		get_parent().add_child(obs)
