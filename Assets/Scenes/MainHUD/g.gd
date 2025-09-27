extends Panel

@onready var gold = $Label

func _process(delta: float) -> void:
	gold.text = str(int(MainGameManager.gold))
