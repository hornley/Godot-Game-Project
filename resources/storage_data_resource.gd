class_name StorageDataResource
extends NodeDataResource

@export var size: int
@export var inventory: Dictionary
@export var empty_inventory_slot: Array
@export var items_count: int

#@export var experience: int = 0
#@export var level: int = 1
#@export var last_position: Vector3 = Vector3(0, 0, 0)
#@export var last_scene: String = "res://scenes/village.tscn"

#@export var total_crops_harvested: int = 0


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	var storage_component: StorageComponent = node.find_child("StorageComponent")
	
	size = storage_component.size
	inventory = storage_component.items
	empty_inventory_slot = storage_component.empty_slots
	items_count = storage_component.items_count

func _load_data(window) -> void:
	var parent_node: Node2D
	var node: Chest
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	if parent_node != null:
		for _node in parent_node.get_tree().get_nodes_in_group("save_data_component"):
			if _node.get_parent().global_position == global_position and node_path == _node.get_parent().get_path():
				node = _node.get_parent()
	
	if parent_node != null and node != null:
		var storage_component: StorageComponent = node.find_child("StorageComponent") as StorageComponent
		storage_component.empty_slots_loaded = true
		
		storage_component.size = size
		storage_component.items = inventory
		storage_component.empty_slots = empty_inventory_slot
		storage_component.items_count = items_count
