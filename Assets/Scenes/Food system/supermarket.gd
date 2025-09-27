extends Control

@onready var output_label: Label = $Label

var foods := {
	"apple": {"price": 10, "stock": 2, "button": null},
	"pizza": {"price": 10, "stock": 2, "button": null},
	"donut": {"price": 10, "stock": 2, "button": null},
	"cereal": {"price": 10, "stock": 2, "button": null},
	"chicken": {"price": 10, "stock": 2, "button": null},
	"cookie": {"price": 10, "stock": 2, "button": null},
}

func _ready() -> void:
	foods.apple.button = $FoodDisplay/Apple
	foods.pizza.button = $FoodDisplay/Pizza
	foods.donut.button = $FoodDisplay/Donut
	foods.cereal.button = $FoodDisplay/Cereal
	foods.chicken.button = $FoodDisplay/Chicken
	foods.cookie.button = $FoodDisplay/Cookie

	for food_name in foods.keys():
		var btn: TextureButton = foods[food_name].button
		btn.pressed.connect(func(): _buy_food(food_name))

	output_label.visible = false

func _buy_food(food_name: String) -> void:
	output_label.visible = true
	var food = foods[food_name]
	var price = food.price
	var stock = food.stock

	if MainGameManager.food_capacity >= MainGameManager.max_food_capacity:
		output_label.text = "Fridge is full! (%d/%d)" % [
			MainGameManager.food_capacity, 
			MainGameManager.max_food_capacity
		]
		return

	if MainGameManager.gold < price:
		output_label.text = "Not enough gold! Need %d, you have %d." % [price, MainGameManager.gold]
		return

	if stock <= 0:
		output_label.text = "%s is out of stock!" % food_name.capitalize()
		return

	MainGameManager.gold -= price
	MainGameManager.food_capacity += 1
	foods[food_name].stock -= 1

	output_label.text = "Bought %s! Stock left: %d | Gold: %d | Fridge: %d/%d" % [
		food_name.capitalize(), 
		foods[food_name].stock, 
		MainGameManager.gold, 
		MainGameManager.food_capacity, 
		MainGameManager.max_food_capacity
	]

	if foods[food_name].stock <= 0:
		foods[food_name].button.disabled = true

func _on_close_button_pressed() -> void:
	MainGameManager.save_game()
	get_tree().change_scene_to_file("res://Assets/Scenes/Main.tscn")
