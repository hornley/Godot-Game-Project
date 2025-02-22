extends Node

var inventory: Dictionary = Dictionary()
var empty_inventory_slot: Array = range(25)
var items_count: int

signal inventory_changed

func add_item(item_name: String, item_resource: ItemResource) -> void:
	if not inventory.has(item_name):
		inventory[item_name] = {
			"ItemResource": item_resource,
			"Amount": 1,
			"Index": empty_inventory_slot.pop_front()
		}
		items_count += 1
	else:
		inventory[item_name]["Amount"] += 1
	
	inventory_changed.emit()

func remove_item(item_name: String) -> void:
	if not inventory.has(item_name):
		return
	
	if inventory[item_name] == 1:
		empty_inventory_slot.append(inventory[item_name]["Index"])
		empty_inventory_slot.sort()
		inventory.erase(item_name)
		items_count -= 1
	else:
		if inventory[item_name] > 1:
			inventory[item_name]["Amount"] -= 1
	
	inventory_changed.emit()

func move_item(item_name: String) -> void:
	pass
