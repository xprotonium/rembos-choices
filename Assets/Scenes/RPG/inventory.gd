extends Node
class_name Inventory

var items: Array[ItemData] = []

func add_item(item: ItemData) -> void:
	if not items.has(item):
		items.append(item)

func has_item(item_name: String):
	for item in items:
		if item.item_name == item_name:
			return true
		return false

func remove_item(item_name: String) -> void:
	for item in items.size():
		if items[item].item_name == item_name:
			items.remove_at(item)
			return
			
