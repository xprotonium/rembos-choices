extends Node2D

@export var radius: float = 6
@export var target_door: Node2D
@onready var area2D: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var unlock_sound: AudioStreamPlayer = $AudioStreamPlayer
var player_in_area: bool = false

@onready var texture: TextureRect = $TextureRect

@export var ui_locked_texture: Texture2D
@export var ui_unlocked_texture: Texture2D

@onready var door: Sprite2D = $Sprite2D
@export var door_locked: Texture2D
@export var door_unlocked: Texture2D

@export var door_switch: DoorSwitch
var audio_played: bool = false
var is_door_locked: bool = true

@export var camera: Camera2D
@export_enum("up", "down") var door_direction: String = "down"


func _ready():
	texture.visible = false
	var circle := collision_shape.shape as CircleShape2D
	if circle:
		circle.radius = radius
	area2D.body_entered.connect(_on_player_enter)
	area2D.body_exited.connect(_on_player_exit)


func _process(_delta: float) -> void:
	door_lock_manager()
	if door_switch and door_switch.hit:
		is_door_locked = false

	if player_in_area and Input.is_action_just_pressed("interact") and not is_door_locked:
		GameManager.player.global_position = target_door.global_position
		match door_direction:
			"up":
				camera.move_vertical_section(-1)
			"down":
				camera.move_vertical_section(1)


func _on_player_enter(body: Node):
	if body is CharacterBody2D:
		texture.visible = true
		player_in_area = true


func _on_player_exit(body: Node):
	if body is CharacterBody2D:
		texture.visible = false
		player_in_area = false


func door_lock_manager():
	if is_door_locked:
		texture.texture = ui_locked_texture
		door.texture = door_locked
	else:
		if not audio_played:
			audio_played = true
			unlock_sound.play()
		texture.texture = ui_unlocked_texture
		door.texture = door_unlocked
