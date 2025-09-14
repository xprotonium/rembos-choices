extends Node2D
class_name Weapon

# weapon appearance
@export var weapon_data: WeaponData = null
@export var sprite: Sprite2D
var cooldown: float

# weapon hitbox
@onready var hitbox = $Area2D

# weapon collision shape, to set collision shape size
@onready var collision_shape = $Area2D/CollisionShape2D

# weapon animation player
@onready var weapon_animations = $WeaponAnimations

func _ready() -> void:
	# set all values from weapon data
	if weapon_data:
		sprite.texture = weapon_data.weapon_sprite
		collision_shape.shape.radius = weapon_data.reach
		cooldown = weapon_data.cooldown
	else:
		sprite.texture = null
		collision_shape.shape.radius = 0
		cooldown = 0
	# disable the hitbox initially
	hitbox.monitoring = false

func _attack():
	if not weapon_data:
		print("No weapon equipped!")
		return
	weapon_animations.play("attack")
	hitbox.monitoring = true
	print(hitbox.monitoring)
	await get_tree().create_timer(cooldown).timeout
	hitbox.monitoring = false
	print(hitbox.monitoring)


func equip_weapon(new_weapon: WeaponData):
	weapon_data = new_weapon
	sprite.texture = weapon_data.sprite
	collision_shape.shape.radius = weapon_data.reach
	cooldown = weapon_data.cooldown


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("detected enemy")
