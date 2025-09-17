extends Camera2D

@export var player_path: NodePath
@export var speed: float = 6.0
var screen_size: Vector2 = Vector2(320, 180) / zoom

var target_position: Vector2
var horizontal_section: int = 0
var vertical_section: int = 0

func _ready() -> void:
	target_position = position
	var player = get_node(player_path) as CharacterBody2D

	for barrier in get_tree().get_nodes_in_group("EntranceBarriers"):
		barrier.connect("body_entered", Callable(self, "on_barrier_triggered").bind("entrance", barrier))
	for barrier in get_tree().get_nodes_in_group("ExitBarriers"):
		barrier.connect("body_entered", Callable(self, "on_barrier_triggered").bind("exit", barrier))

func _process(delta: float) -> void:
	position = position.lerp(target_position, speed * delta)

func on_barrier_triggered(body: Node2D, kind: String, barrier: Area2D):
	if body != GameManager.player:
		return

	if kind == "entrance":
		target_position.x += screen_size.x
		body.position.x += 16
		horizontal_section += 1
	elif kind == "exit":
		target_position.x -= screen_size.x
		body.position.x -= 16
		horizontal_section -= 1

	GameManager.horizontal_section = horizontal_section

func move_vertical_section(direction: int) -> void:
	vertical_section += direction
	GameManager.vertical_section = vertical_section
	target_position.y = vertical_section * screen_size.y
