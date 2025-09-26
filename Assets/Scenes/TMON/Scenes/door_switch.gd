extends Node2D
class_name DoorSwitch

@onready var sprite: Sprite2D = $Sprite2D
@onready var area2d: Area2D = $Area2D
@onready var unlock_audio = $AudioStreamPlayer

@export var sprite_locked: Texture2D
@export var sprite_unlocked: Texture2D

var hit: bool = false
var player_in_area: bool = false

func _ready() -> void:
	sprite.texture = sprite_locked
	area2d.body_entered.connect(_on_body_entered)
	area2d.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if hit:
		return

	if player_in_area and Input.is_action_just_pressed("interact"):
		_activate()

func _on_body_entered(body: Node) -> void:
	if body == GameManager.player:
		player_in_area = true

func _on_body_exited(body: Node) -> void:
	if body == GameManager.player:
		player_in_area = false

func _activate() -> void:
	hit = true
	unlock_audio.play()
	sprite.texture = sprite_unlocked
