extends Node2D
class_name Weapon

# weapon appearance
@export var weapon_sprite: Texture2D
@onready var sprite2d = $Sprite2D

# weapon stats
@export var damage: int
@export var reach: int
@export var cooldown: float

# weapon hitbox
@onready var hitbox = $Area2D

# weapon collision shape, to set collision shape size
@onready var collision_shape = $Area2D/CollisionShape2D

# weapon animation player
@onready var weapon_animations = $WeaponAnimations

func _ready() -> void:
	# disable the hitbox initially
	hitbox.monitoring = false
	# change the weapon sprite
	sprite2d.texture = weapon_sprite
	# apply the actual reach value of the weapona
	collision_shape.shape.radius = reach

func _attack():
	weapon_animations.play("attack")
	hitbox.monitoring = true
	print(hitbox.monitoring)
	await get_tree().create_timer(cooldown).timeout
	hitbox.monitoring = false
	print(hitbox.monitoring)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemies"):
		print("detected enemy")
