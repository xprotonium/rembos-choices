extends Node2D

@onready var timer: Timer = $QTETimer
@onready var e_container = $PerfectTimingUI/ContainerE
@onready var q_container = $PerfectTimingUI/ContainerQ
@export var enemy: Node2D
@export var player: Node2D
@export var death_screen: Control
@onready var qte_effect = $QTEEffect
@onready var energy:int = MainGameManager.energy


var expected_key = ""
var qte_active = false
var min_energy = 5

func _ready():
	await get_tree().create_timer(3.0).timeout
	randomize()
	timer.timeout.connect(_on_qte_failed)
	start_qte()
	
func _process(_delta: float) -> void:
	if player.hp == 0 or enemy.hp == 0:
		death_screen.visible = true
		get_tree().paused = true

func start_qte():
	if qte_active:
		return

	var choices = ["qte_e", "qte_q"]
	expected_key = choices.pick_random()

	e_container.hide()
	q_container.hide()

	if expected_key == "qte_e":
		e_container.show()
		e_container.button_ani_player.play("QTE")
		if energy > min_energy :
			qte_effect.play()
	else:
		q_container.show()
		q_container.button_ani_player.play("QTE")
		if energy > min_energy :
			qte_effect.play()

	timer.start()
	qte_active = true

func _unhandled_input(event: InputEvent):
	if not qte_active:
		return

	# Correct key pressed
	if event.is_action_pressed(expected_key):
		enemy._take_dmg(10)
		_end_qte()
	# Wrong QTE key pressed
	elif event.is_action_pressed("qte_e") or event.is_action_pressed("qte_q"):
		player._take_dmg(50)
		_end_qte()

func _on_qte_failed():
	if qte_active:
		player._take_dmg(50)
		_end_qte()

func _end_qte():
	qte_active = false
	expected_key = ""
	timer.stop()

	# Hide containers
	e_container.hide()
	q_container.hide()

	# Short delay before next QTE
	await get_tree().create_timer(0.5).timeout
	
	start_qte()
