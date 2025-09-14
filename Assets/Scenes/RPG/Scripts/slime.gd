extends CharacterBody2D

enum State { IDLE, CHASE, ATTACK, HURT, DEAD }

@export var speed: float = 20
@export var max_hp: int = 10
@export var gravity: float = 300
@export var jump_force: float = 150
@export var section_id: int
@export var attack_cd: float = 2.0
@export var attack_damage: int = 10
@export var knockback_strength: float = 100

var state: State = State.IDLE
var hp: int
var spawn_position: Vector2
var attack_timer: float = 0.0
var knockback_velocity: Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_range = $AttackRange

func _ready() -> void:
	add_to_group("Enemy")
	hp = max_hp
	spawn_position = global_position
	sprite.play("idle")
	sprite.animation_finished.connect(_on_animation_finished)
	attack_range.monitoring = false

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		return

	if knockback_timer > 0:
		velocity = knockback_velocity
		knockback_timer -= delta
	else:
		if not is_on_floor():
			velocity.y += gravity * delta

		match state:
			State.IDLE:
				if GameManager.current_section == section_id:
					state = State.CHASE
				else:
					_reset_enemy()

			State.CHASE:
				if GameManager.player:
					var dx = GameManager.player.global_position.x - global_position.x
					if dx != 0:
						velocity.x = sign(dx) * speed
						if dx > 0:
							sprite.play("walk_right")
						else:
							sprite.play("walk_left")

					if attack_timer > 0:
						attack_timer -= delta

					if attack_timer <= 0 and _player_in_attack_range():
						state = State.ATTACK

			State.ATTACK:
				if is_on_floor():
					sprite.play("attack_land")
				else:
					sprite.play("attack_jump")
				_attack()

			State.HURT:
				sprite.play("hurt")
				velocity.x = 0

	move_and_slide()

func _take_damage(amount: int, from_position: Vector2) -> void:
	if state == State.DEAD:
		return

	hp -= amount
	if hp > 0:
		state = State.HURT
		sprite.play("hurt")
		var direction = (global_position - from_position).normalized()
		knockback_velocity = Vector2(direction.x * knockback_strength, -knockback_strength / 2)
		knockback_timer = 0.2
	else:
		_die()

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

func _attack() -> void:
	attack_range.monitoring = true
	attack_timer = attack_cd
	var dir = (GameManager.player.global_position - global_position).normalized()
	velocity.y = -jump_force
	state = State.CHASE

func _player_in_attack_range() -> bool:
	if not GameManager.player:
		return false
	var distance = GameManager.player.global_position.distance_to(global_position)
	return distance <= 40

func _reset_enemy() -> void:
	hp = max_hp
	global_position = spawn_position
	velocity = Vector2.ZERO
	state = State.IDLE
	attack_timer = 0.0
	sprite.play("idle")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		if state == State.IDLE:
			state = State.CHASE

func _on_attack_range_body_entered(body: Node2D) -> void:
	if body == GameManager.player:
		GameManager.player.take_dmg(attack_damage)
		var direction = (body.global_position - global_position).normalized()
		body.velocity = Vector2(direction.x * knockback_strength, -knockback_strength / 2)
