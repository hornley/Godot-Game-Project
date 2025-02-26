class_name PlayerDataResource
extends SceneDataResource

@export var player_name: String
@export var coins: int
@export var inventory: Dictionary
@export var empty_inventory_slot: Array
@export var items_count: int
@export var completed_quests: Array[QuestResource]
@export var active_quests: Array[QuestResource]

#@export var experience: int = 0
#@export var level: int = 1
#@export var last_position: Vector3 = Vector3(0, 0, 0)
#@export var last_scene: String = "res://scenes/village.tscn"

#@export var total_crops_harvested: int = 0


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	player_name = PlayerManager.name
	coins = PlayerManager.coins
	inventory = PlayerManager.inventory
	empty_inventory_slot = PlayerManager.empty_inventory_slot
	items_count = PlayerManager.items_count
	completed_quests = PlayerManager.completed_quests
	active_quests = PlayerManager.active_quests

func _load_data(window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Node2D
	
	if parent_node != null and scene_node != null:
		print("Loading")
		PlayerManager.name = player_name
		PlayerManager.coins = coins
		PlayerManager.inventory = inventory
		PlayerManager.empty_inventory_slot = empty_inventory_slot
		PlayerManager.items_count = items_count
		PlayerManager.completed_quests = completed_quests
		PlayerManager.active_quests = active_quests
		
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
