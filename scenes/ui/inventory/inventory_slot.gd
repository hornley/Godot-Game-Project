class_name InventorySlot extends Button

@onready var center_container: CenterContainer = $CenterContainer

var item_stack: InventoryItemStack

func update(_item_stack: InventoryItemStack) -> void:
	item_stack = _item_stack
	center_container.add_child(item_stack)

func take_item() -> InventoryItemStack:
	if !item_stack:
		return null
	
	var item = item_stack
	
	item_stack = null
	center_container.remove_child(item)
	
	return item

func remove_item() -> void:
	if !item_stack:
		return
	
	var item = item_stack
	
	item_stack = null
	center_container.remove_child(item)

func get_item_resource() -> ItemResource:
	if !item_stack:
		return null
	return item_stack.item_resource

func is_empty() -> bool:
	if item_stack:
		return false
	return true
