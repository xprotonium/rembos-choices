extends Camera2D

# To achieve this effect, an Area2D trigger will be placed 
# at the edge of each section

# As the player collides with the Area2D, the camera will jump
# to the next section

# Each section will have a section number to it for 
# future referncing purposes

# -----------------------------------------------------------

# player variables
@export var player_path: NodePath

# Area2D exit entrance status
var has_entered = false

# Camera variables
var screen_size = Vector2(320, 180) / zoom

# changes based on if the player moves backward, forward, up, down
var current_section: int = 0
var target_position: Vector2
@export var speed = 6

func _ready() -> void:
	# get the player body:
	var player = get_node(player_path) as CharacterBody2D
	for barrier in get_tree().get_nodes_in_group("EntranceBarriers"):
		barrier.connect("body_entered", Callable(self, "on_barrier_triggered").bind("entrance", barrier))
	for barrier in get_tree().get_nodes_in_group("ExitBarriers"):
		barrier.connect("body_entered", Callable(self, "on_barrier_triggered").bind("exit", barrier))
		
func _process(delta: float) -> void:
	position = position.lerp(target_position, speed * delta)

func on_barrier_triggered(body: Node2D, kind: String, barrier: Area2D):
	# check if it is the player
	if not GameManager.player:
		return
		
	if kind == "entrance":
		target_position.x += screen_size.x
		body.position.x += 16
		current_section += 1
	elif kind == "exit":
		target_position.x -= screen_size.x
		body.position.x -= 16
		current_section -= 1
		
	GameManager.current_section = current_section
