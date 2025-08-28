extends Control

@onready var sigmantosh_menu = $SigmantoshMenu
# since the player is an instanced node, we need the node path
# then use it as root node
@export var player_path: NodePath
var player: CharacterBody2D

func _ready() -> void:
	# we use the path to get the root node
	# then get the characterbody2d in which the script is stored in
	# i wonder what happens if i move the script to the main node itself lmao
	var player_scene = get_node(player_path)
	player = player_scene.get_node("CharacterBody2D") as CharacterBody2D

func _process(delta: float) -> void:
	if self.visible:
		player.allow_movement = false

func _on_exit_button_pressed() -> void:
	# hide the PC UI when the player exits it and also reset the values
	self.visible = false
	sigmantosh_menu.visible = false
	player.allow_movement = true


func _on_sigmantosh_button_pressed() -> void:
	# bring up the ui when proximity button is pressed
	if not sigmantosh_menu.visible:
		sigmantosh_menu.visible = true
	else:
		sigmantosh_menu.visible = false
