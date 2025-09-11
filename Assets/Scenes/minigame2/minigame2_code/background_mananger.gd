extends Node2D

@onready var bg1 = $BG1
@onready var bg2 = $BG2
@onready var player_detector = $BG2/Area2D

var scroll_speed = 4

var game_time: float = 0.0
var max_scroll_speed: float = 100.0
var acceleration: float = 0.33

func _ready() -> void:
	player_detector.body_entered.connect(_on_player_enter)
	player_detector.body_exited.connect(_on_player_exit)

func _process(delta: float) -> void:
	
	game_time += delta
	var current_speed = min(scroll_speed + (acceleration * game_time), max_scroll_speed)
	
	self.position.x += -1 * current_speed

func _on_player_enter(body: Node):
	if body is CharacterBody2D:
		bg1.position.x += 640

func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		bg2.position.x += 640

func stop_scrolling():
	set_process(false)
	print("Background scrolling stopped")
