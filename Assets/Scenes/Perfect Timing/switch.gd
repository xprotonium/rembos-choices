extends StaticBody2D

# bools
var player_in_area = false
var is_gate_locked = true

# sprites for the switch
@onready var sprite = $ButtonSprite
@export var button_red: Texture2D
@export var button_green: Texture2D
@onready var gate= $"../gate_animation"
@onready var timer: Timer = $"../GateTimer"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = button_red
	gate.visible = false
	timer.timeout.connect(_on_timer_timeout)

# Called every frame. 'delta' is the elapsed time since the previous frame
func _process(_delta: float) -> void:
	if player_in_area and Input.is_action_just_pressed("interact"):
		is_gate_locked = false
		sprite.texture = button_green
		gate.visible = true
		gate.play("gate_opening")
		timer.start()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body is CharacterBody2D:
		player_in_area = false
		
func _on_timer_timeout() -> void:
	sprite.texture = button_red
	gate.play_backwards("gate_opening")
	is_gate_locked = true
	await get_tree().create_timer(1.333).timeout
	gate.visible = false
