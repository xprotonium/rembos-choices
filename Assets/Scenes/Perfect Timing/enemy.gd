extends Node2D

@export var max_hp: int = 100
@export var hp = 100

# progress bar
@export var hp_bar: ProgressBar

func _ready() -> void:
	hp = max_hp
	hp_bar.value = max_hp

func _process(delta: float) -> void:
	if hp == 0:
		pass
		
func _take_dmg(amount: int):
	hp -= amount
	hp_bar.value -= amount
