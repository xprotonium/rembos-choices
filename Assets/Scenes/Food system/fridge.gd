extends Control

@onready var apple: TextureButton   = $FoodDisplay/Apple
@onready var pizza: TextureButton   = $FoodDisplay/Pizza
@onready var donut: TextureButton   = $FoodDisplay/Donut
@onready var cereal: TextureButton  = $FoodDisplay/Cereal
@onready var chicken: TextureButton = $FoodDisplay/Chicken
@onready var cookie: TextureButton  = $FoodDisplay/Cookie

var fridge_items: Array = []

func _ready() -> void:
	for food in get_all_foods():
		food.visible = false
		food.disabled = true
		food.pressed.connect(func(): eat_food(food))

	_fill_fridge()

func get_all_foods() -> Array:
	return [apple, pizza, donut, cereal, chicken, cookie]

func _fill_fridge() -> void:
	fridge_items.clear()
	var available_foods = get_all_foods().duplicate()
	available_foods.shuffle()
	
	for i in range(min(MainGameManager.food_capacity, available_foods.size())):
		var chosen = available_foods[i]
		fridge_items.append(chosen)
		chosen.visible = true
		chosen.disabled = false

func eat_food(food_node: TextureButton) -> void:
	if food_node in fridge_items:
		food_node.visible = false
		food_node.disabled = true
		fridge_items.erase(food_node)
		MainGameManager.food_capacity = max(MainGameManager.food_capacity - 1, 0)
		MainGameManager.eat_food()

func _on_close_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
