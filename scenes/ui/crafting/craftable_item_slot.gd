class_name CraftableItemSlot extends Button

@onready var center_container: CenterContainer = $CenterContainer

var item_stack: CraftableItemStack

func update(_item_stack: CraftableItemStack) -> void:
	item_stack = _item_stack
	center_container.add_child(item_stack)

func get_item_recipe_resource() -> ItemRecipeResource:
	if !item_stack:
		return null
	return item_stack.item_recipe_resource

func is_empty() -> bool:
	if item_stack:
		return false
	return true
