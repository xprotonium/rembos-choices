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
		print("No weapon equipped!")
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
		print("Hit enemy!")
		print("Body name: ", body.name)
		print("Body has _take_damage method: ", body.has_method("_take_damage"))
		if body.has_method("_take_damage"):
			print("Calling _take_damage with damage: ", weapon_data.damage, " and position: ", GameManager.player.position)
			body._take_damage(weapon_data.damage, GameManager.player.position)
			print("_take_damage call completed")
		else:
			print("Body doesn't have _take_damage method!")
