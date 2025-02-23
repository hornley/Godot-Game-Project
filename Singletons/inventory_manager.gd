extends Node

var inventory: Dictionary = Dictionary()
var empty_inventory_slot: Array = range(25)
var items_count: int

signal inventory_changed

func add_item(item_name: String, item_resource: ItemResource, amount: int) -> void:
	if not inventory.has(item_name):
		inventory[item_name] = {
			"ItemResource": item_resource,
			"Amount": amount,
			"Index": empty_inventory_slot.pop_front()
		}
		items_count += 1
	else:
		inventory[item_name]["Amount"] += amount
	
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

func move_item(item_name: String, new_index: int) -> void:
	empty_inventory_slot.append(inventory[item_name]["Index"])
	inventory[item_name]["Index"] = new_index
	empty_inventory_slot.sort()
	
	inventory_changed.emit()

func swap_item(item_name_1: String, item_1_new_index: int, item_name_2: String, item_2_new_index: int) -> void:
	inventory[item_name_1]["Index"] = item_1_new_index
	inventory[item_name_2]["Index"] = item_2_new_index
	
	inventory_changed.emit()
