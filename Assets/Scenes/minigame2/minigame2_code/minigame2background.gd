extends Sprite2D

@export var base_scroll_speed: float = 200.0  # Faster starting speed
@export var max_scroll_speed: float = 1000.0  # INSANE maximum speed
@export var acceleration_rate: float = 2.0    # Rapid speed increase

var current_scroll_speed: float
var game_active = true
var game_time: float = 0.0

func _ready():
	current_scroll_speed = base_scroll_speed
	print("Background started at CRAZY speed: ", current_scroll_speed)

func _process(delta):
	if not game_active:
		return  # Stop moving if game is over
	
	# Increase game time and speed RAPIDLY
	game_time += delta
	current_scroll_speed = min(base_scroll_speed + (acceleration_rate * game_time * game_time), max_scroll_speed)
	
	# Scroll background with INSANE speed
	position.x -= current_scroll_speed * delta
	
	# Loop background
	if position.x <= -texture.get_size().x:
		position.x += texture.get_size().x * 2
	
	# Show speed every second (it'll get crazy fast!)
	if int(game_time) % 1 == 0:
		print("CRAZY SPEED: ", int(current_scroll_speed))

func stop_scrolling():
	game_active = false
	print("Background scrolling stopped at INSANE speed: ", int(current_scroll_speed))

func get_current_speed() -> float:
	return current_scroll_speed
