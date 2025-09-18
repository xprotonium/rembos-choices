extends CharacterBody2D

@export var max_hp = 100
@export var hp = 100
@export var default_speed: float = 50
@export var speed = 50
@export var g = 900
@export var default_jump: float = 170
@export var jump_force = 170
@export var friction = 0.1
@export var hp_bar: TextureProgressBar 
@export var hp_text: Label

var cooldown: float 
@onready var sprite = $Sprite2D
@onready var weapon: Node = null
@onready var hurt_audio = $HURT
@onready var death_audio = $DEATH
var can_attack: bool = true
@onready var player_animation = $PlayerAnimations
var prev_direction = "right"
@export var inventory := {}

@export var death_screen: Panel
@export var bg_ost: AudioStreamPlayer

func _ready() -> void:
	GameManager.player = self

func get_input():
	if GameManager.console_open:
		velocity.x = 0
		return
	
	var input_direction = 0
	if Input.is_action_pressed("left"):
		input_direction -= 1
		player_animation.play("walk")
		sprite.scale.x = -1
		prev_direction = "left"
	if Input.is_action_pressed("right"):
		input_direction += 1
		player_animation.play("walk")
		sprite.scale.x = 1
		prev_direction = "right"
	if input_direction != 0:
		velocity.x = input_direction * speed
	else:
		velocity.x = lerp(velocity.x, 0.0, friction)
		if prev_direction == "right":
			sprite.scale.x = 1
		else:
			sprite.scale.x = -1
		player_animation.play("idle")

func check_attack():
	if can_attack and Input.is_action_just_pressed("attack") and weapon:
		can_attack = false
		weapon._attack()
		await get_tree().create_timer(weapon.cooldown).timeout
		can_attack = true

func take_dmg(dmg: int):
	hp -= dmg
	hp = max(hp, 0)
	hp_bar.value = hp
	hp_text.text = str(hp)

	if hp == 0:
		death_screen.visible = true
		get_tree().paused = true
		bg_ost.stop()
		death_audio.play()
	else:
		hurt_audio.play()

func equip_weapon(item_name: String) -> void:
	if not inventory.has(item_name):
		return
	if weapon and weapon.is_inside_tree():
		weapon.queue_free()
	var weapon_path: String = inventory[item_name]
	var weapon_scene: PackedScene = load(weapon_path)
	weapon = weapon_scene.instantiate()
	$WeaponHolder.add_child(weapon)

func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
	velocity.y += g * delta
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y -= jump_force
	check_attack()




func _on_spikes_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		GameManager.player.take_dmg(GameManager.player.hp)
