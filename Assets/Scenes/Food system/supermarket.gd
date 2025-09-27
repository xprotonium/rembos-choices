extends Node2D

var food_price = 10
var food = 1
@onready var food_capacity:int = MainGameManager.food_capacity
@onready var gold:int = MainGameManager.gold
@onready var max_food_capacity:int = MainGameManager.max_food_capacity
@onready var buy_button = $BuyButton

func _ready() -> void:
	buy_button.pressed.connect(_on_button_pressed)

func _on_button_pressed() -> void:
	if gold < food_price:
		print("you dont have enough money for this")
		
	elif food_capacity == max_food_capacity:
		print("no fatass the fridge is full")
		
	else:
		gold -= food_price
		food_capacity += 1
		print("added to fridge")
	
	print(food_capacity)
	print(gold)
