extends Node2D

@export var max_hp: int = 100
@export var hp = 100

# progress bar
@export var hp_bar: TextureProgressBar
@export var hp_label: Label

func _ready() -> void:
	hp = max_hp
	hp_bar.value = max_hp
	hp_label.text = str(max_hp)

func _process(_delta: float) -> void:
	if hp == 0:
		pass
		
func _take_dmg(amount: int):
	hp -= amount
	hp_bar.value -= amount
	hp_label.text = str(hp)
