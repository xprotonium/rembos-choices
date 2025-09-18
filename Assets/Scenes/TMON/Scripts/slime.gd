extends CharacterBody2D

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }

@export var speed: float = 20
@export var max_hp: int = 10
@export var gravity: float = 300
@export var jump_force: float = 150
@export var attack_cd: float = 2.0
@export var attack_damage: int = 10
@export var knockback_strength: float = 100
@export var attack_range_radius: float = 2.5
@export var attack_duration: float = 0.5
@export var horizontal_section_id: int = 0
@export var vertical_section_id: int = 0

@onready var got_hit_audio = $GotHit
@onready var death_audio = $Death
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var attack_hitbox: Area2D = $AttackHitBox
@onready var attack_hitbox_shape: CollisionShape2D = $AttackHitBox/CollisionShape2D

var state: State = State.IDLE
var hp: int
var spawn_position: Vector2
var attack_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0
var off_section: bool = false
var attack_in_progress: bool = false
var attack_animation_played: bool = false

func _ready() -> void:
	print(vertical_section_id, horizontal_section_id)
	add_to_group("Enemy")
	hp = max_hp
	spawn_position = global_position
	sprite.play("idle")
	sprite.animation_finished.connect(_on_animation_finished)

	# Setup attack hitbox
	(attack_hitbox_shape.shape as CircleShape2D).radius = attack_range_radius
	attack_hitbox.monitoring = false
	if not attack_hitbox.body_entered.is_connected(_on_attack_hitbox_body_entered):
		attack_hitbox.body_entered.connect(_on_attack_hitbox_body_entered)

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return

	# Section check
	if GameManager.horizontal_section != horizontal_section_id or GameManager.vertical_section != vertical_section_id:
		if not off_section:
			_reset_enemy()
			off_section = true
		return
	else:
		off_section = false

	# Knockback handling
	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
		velocity.y += gravity * delta
	else:
		if not is_on_floor():
			velocity.y += gravity * delta

	# State machine
	match state:
		State.IDLE:
			state = State.CHASE
		State.CHASE:
			_chase_player(delta)
		State.ATTACK:
			_attack_player(delta)
		State.HURT:
			sprite.play("hurt")
			velocity.x = 0

	move_and_slide()

func _chase_player(delta: float) -> void:
	if GameManager.player:
		var dx = GameManager.player.global_position.x - global_position.x
		if dx != 0:
			velocity.x = sign(dx) * speed
			sprite.play("walk_right" if dx > 0 else "walk_left")
		# Ready to attack if cooldown finished
		if attack_timer > 0:
			attack_timer -= delta
		elif not attack_in_progress:
			state = State.ATTACK
			attack_in_progress = true
			attack_animation_played = false
			attack_timer = attack_cd

func _attack_player(delta: float) -> void:
	if attack_in_progress:
		if is_on_floor():
			if GameManager.player:
				var dir = (GameManager.player.global_position - global_position).normalized()
				velocity.x = dir.x * speed
				velocity.y = -jump_force
				sprite.play("attack_jump")
		else:
			sprite.play("attack_jump")

		# Enable hitbox for damage
		if not attack_animation_played:
			attack_hitbox.monitoring = true
			attack_animation_played = true
			await get_tree().create_timer(attack_duration).timeout
			attack_hitbox.monitoring = false
			attack_in_progress = false
			state = State.CHASE
			sprite.play("idle")

		attack_timer = max(attack_timer - delta, 0)

func _take_damage(amount: int, from_position: Vector2) -> void:
	if state == State.DEAD:
		return

	hp -= amount
	if hp > 0:
		state = State.HURT
		sprite.play("hurt")
		got_hit_audio.play()
		var direction = (global_position - from_position).normalized()
		knockback_velocity = Vector2(direction.x * knockback_strength, -jump_force * 0.5)
		knockback_timer = 0.2
	else:
		_die()

func _reset_enemy() -> void:
	hp = max_hp
	global_position = spawn_position
	velocity = Vector2.ZERO
	state = State.IDLE
	attack_timer = 0.0
	attack_in_progress = false
	attack_hitbox.monitoring = false
	sprite.play("idle")

func _on_animation_finished() -> void:
	if sprite.animation == "hurt" and state == State.HURT:
		state = State.CHASE
		sprite.modulate = Color(1, 1, 1)
		sprite.play("idle")
	elif sprite.animation == "death":
		queue_free()

func _die() -> void:
	state = State.DEAD
	velocity = Vector2.ZERO
	sprite.play("death")
	death_audio.play()

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		GameManager.player.take_dmg(attack_damage)
		var dir_x = sign(GameManager.player.global_position.x - global_position.x)
		GameManager.player.velocity.x = dir_x * knockback_strength
		GameManager.player.velocity.y = -knockback_strength * 0.2
