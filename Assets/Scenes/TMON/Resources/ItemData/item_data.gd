extends Resource
class_name ItemData
# this is the base for all type of items the player can
# come across

# by checking the item type we can decide 
# what to do with the current item
enum item_type { GENERIC, WEAPON, KEY, CONSUMABLE }

@export var item_name: String
@export var item_description: String
@export var item_icon: Texture2D
