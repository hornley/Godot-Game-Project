class_name PlayerDataResource
extends SceneDataResource

@export var player_name: String
@export var coins: int
@export var inventory: Dictionary
@export var empty_inventory_slot: Array
@export var items_count: int
@export var hotbar_array: Array[ItemResource]
@export var completed_quests: Dictionary
@export var active_quests: Dictionary

@export var save_version: String

#@export var experience: int = 0
#@export var level: int = 1
#@export var last_position: Vector3 = Vector3(0, 0, 0)
#@export var last_scene: String = "res://scenes/village.tscn"

#@export var total_crops_harvested: int = 0


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	player_name = PlayerManager.name
	coins = PlayerManager.coins
	inventory = PlayerManager.inventory.items
	empty_inventory_slot = PlayerManager.inventory.empty_slots
	items_count = PlayerManager.inventory.items_count
	hotbar_array = HotbarManager.hotbar_array
	completed_quests = PlayerManager.completed_quests
	active_quests = PlayerManager.active_quests
	
	save_version = GameManager.game_version

func _load_data(window) -> void:
	var parent_node: Node2D
	var scene_node: Player
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Player
	
	if parent_node != null and scene_node != null:
		var storage_component: StorageComponent = scene_node.find_child("StorageComponent") as StorageComponent
		storage_component.empty_slots_loaded = true
		
		PlayerManager.name = player_name
		PlayerManager.add_coin(coins)
		storage_component.items = inventory
		storage_component.empty_slots = empty_inventory_slot
		storage_component.items_count = items_count
		HotbarManager.hotbar_array = hotbar_array
		PlayerManager.completed_quests = completed_quests
		PlayerManager.active_quests = active_quests
		
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
		HotbarManager.hotbar_changed.emit(-1)
