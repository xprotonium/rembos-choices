extends Node2D

@onready var bg1 = $BG1
@onready var bg2 = $BG2
@onready var player_detector = $BG2/Area2D

var scroll_speed = 4

func _ready() -> void:
	player_detector.body_entered.connect(_on_player_enter)
	player_detector.body_exited.connect(_on_player_exit)

func _process(delta: float) -> void:
	self.position.x += -1 * scroll_speed

func _on_player_enter(body: Node):
	if body is CharacterBody2D:
		bg1.position.x += 320 * 2

func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		bg2.position.x += 320 * 2
