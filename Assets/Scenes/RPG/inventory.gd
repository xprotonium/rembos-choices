extends Node
class_name Inventory

var items: Array[ItemData] = []

func add_item(item: ItemData) -> void:
	if not items.has(item):
		items.append(item)
