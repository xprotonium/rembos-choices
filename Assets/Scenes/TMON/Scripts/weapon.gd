extends Node2D
class_name Weapon

@export var weapon_data: WeaponData = null
@export var sprite: Sprite2D
var cooldown: float

@onready var hitbox: Area2D = $Area2D
@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D
@onready var weapon_animations: AnimationPlayer = $WeaponAnimations

func _ready() -> void:
	if weapon_data:
		sprite.texture = weapon_data.weapon_sprite
		collision_shape.shape.radius = weapon_data.reach
		cooldown = weapon_data.cooldown
	else:
		sprite.texture = null
		collision_shape.shape.radius = 0
		cooldown = 0

	# disable hitbox initially
	hitbox.monitoring = false

	# connect signal for detecting enemies
	hitbox.body_entered.connect(_on_body_entered)


func _attack():
	if not weapon_data:
		return

	weapon_animations.play("attack")
	hitbox.monitoring = true

	await weapon_animations.animation_finished
	hitbox.monitoring = false

	await get_tree().create_timer(cooldown).timeout


func _on_body_entered(body: Node2D) -> void:
	if not hitbox.monitoring: 
		return  # Only apply damage while attacking
	if body.is_in_group("Enemy"):
		if body.has_method("_take_damage"):
			body._take_damage(weapon_data.damage, GameManager.player.position)
