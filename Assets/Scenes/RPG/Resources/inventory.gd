extends Node
class_name ItemData

# the different types of classes that a packed scene can be
enum ItemType { GENERIC, WEAPON, KEY, CONSUMABLE }

@export var item_name: String
@export var description: String
@export var icon: Texture2D
@export var type: ItemType = ItemType.GENERIC

# used for storing weapon scenes if the item is a weapon
@export var weapon_scene: PackedScene

# used for keys
@export var key_id: String = ""
