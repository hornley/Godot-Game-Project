class_name StorageComponent extends Node

@export var size: int
@export var items: Dictionary = Dictionary()
var items_count: int = 0
var empty_slots: Array
var empty_slots_loaded: bool

signal storage_changed(item: ItemResource)

'''
{
	"ItemResource": item_resource,
	"Amount": amount,
	"Index": empty_inventory_slot.pop_front()
}
'''

func _ready() -> void:
	if !empty_slots_loaded:
		empty_slots = range(size)

func add_item(item_name: String, amount: int) -> bool:
	# Item does not exist in items or seeds
	if item_name not in GameDataManager.items.keys() and item_name not in GameDataManager.seeds.keys():
		return false
	
	# No empty slots for the storage
	if empty_slots.size() == 0:
		return false
	
	var item_resource: ItemResource = GameDataManager.get_item(item_name)
	if not items.has(item_name):
		items[item_name] = {
			"ItemResource": item_resource,
			"Amount": amount,
			"Index": empty_slots.pop_front()
		}
		items_count += 1
	else:
		items[item_name]["Amount"] += amount
	
	storage_changed.emit(item_resource)
	return true

func get_item(item_name: String) -> ItemResource:
	if not items.has(item_name):
		return
	
	var item = items[item_name]["ItemResource"]
	
	if items[item_name]["Amount"] == 1:
		empty_slots.append(items[item_name]["Index"])
		empty_slots.sort()
		items_count -= 1
		items.erase(item_name)
	else:
		items[item_name]["Amount"] -= 1
	
	storage_changed.emit(item)
	return item

func remove_item(item_name: String, amount: int) -> ItemResource:
	if not items.has(item_name):
		return
	
	var item = items[item_name]["ItemResource"]
	
	if items[item_name]["Amount"] <= amount:
		empty_slots.append(items[item_name]["Index"])
		empty_slots.sort()
		items_count -= 1
		items.erase(item_name)
	else:
		items[item_name]["Amount"] -= amount
	
	storage_changed.emit(null)
	return item

func transfer_item(item: ItemResource, amount: int, new_index: int, other_storage_component: StorageComponent) -> void:
	var item_name = item.name
	# FROM current
	if self.get_parent() is Player:
		PlayerManager.remove_item(item_name, amount)
	else:
		remove_item(item_name, amount)
	
	# TO other
	if other_storage_component.items.has(item_name):
		other_storage_component.items[item_name]["Amount"] += amount
	else:
		other_storage_component.items[item_name] = {
				"ItemResource": item,
				"Amount": amount,
				"Index": new_index
			}
		other_storage_component.items_count += 1
		other_storage_component.empty_slots.remove_at(other_storage_component.empty_slots.find(new_index))
		other_storage_component.empty_slots.sort()
	
	storage_changed.emit(null)
	other_storage_component.storage_changed.emit(item)

func move_item(item_name: String, new_index: int) -> void:
	empty_slots.append(items[item_name]["Index"])
	items[item_name]["Index"] = new_index
	empty_slots.remove_at(empty_slots.find(new_index))
	empty_slots.sort()
	
	storage_changed.emit(null)

func swap_item(item_name_1: String, item_1_new_index: int, item_name_2: String, item_2_new_index: int) -> void:
	items[item_name_1]["Index"] = item_1_new_index
	items[item_name_2]["Index"] = item_2_new_index
	
	storage_changed.emit(null)
