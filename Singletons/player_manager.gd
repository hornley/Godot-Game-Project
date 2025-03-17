extends Node

var player: Player
var path: Array
var current_path_index: int
var player_name: String
var coins: int
var inventory: StorageComponent
var completed_quests: Array[QuestResource]
var active_quests: Array[QuestResource]

signal inventory_changed(item: ItemResource)
signal player_loaded
signal player_coin_add
signal player_path_find
signal player_path_find_finished(is_successful: bool)

func toggle_player_movement() -> void:
	player.disable_input_events = !player.disable_input_events

func add_coin(amount: int) -> void:
	coins += amount
	player_coin_add.emit()

func set_path_find(_path: Array) -> void:
	clear_path()
	path = _path
	player_path_find.emit()

func clear_path() -> void:
	path = []
	current_path_index = 0

func _player_name_prompt() -> void:
	var player_name_prompt_path = preload("res://scenes/ui/player_name_prompt.tscn")
	var player_name_prompt_instance = player_name_prompt_path.instantiate() as CanvasLayer
	get_parent().add_child(player_name_prompt_instance)
	player.disable_input_events = true
	await player_name_prompt_instance.player_name_prompt_finished

# PLAYER INVENTORY SYSTEM
func on_player_inventory_changed(item: ItemResource) -> void:
	inventory_changed.emit(item)

func add_item(item_name: String, item_resource: ItemResource, amount: int) -> bool:
	return inventory.add_item(item_name, item_resource, amount)

func get_item(item_name: String) -> ItemResource:
	return inventory.get_item(item_name)

func remove_item(item_name: String, amount: int) -> void:
	var item: ItemResource = inventory.remove_item(item_name, amount)
	
	if !inventory.items.has(item_name) and HotbarManager.hotbar_array.find(item) != -1:
		HotbarManager.remove_from_hotbar(HotbarManager.hotbar_array.find(item))
		HotbarManager.unequip_item()
	
	inventory_changed.emit(null)

func move_item(item_name: String, new_index: int) -> void:
	inventory.move_item(item_name, new_index)

func swap_item(item_name_1: String, item_1_new_index: int, item_name_2: String, item_2_new_index: int) -> void:
	inventory.swap_item(item_name_1, item_1_new_index, item_name_2, item_2_new_index)

func craft_item(item_recipe_resource: ItemRecipeResource) -> void:
	#var can_be_crafted: bool = true
	for key in item_recipe_resource.input.keys():
		var amount = item_recipe_resource.input[key]
		if !inventory.items.has(key) or inventory.items[key]["Amount"] < amount:
			#can_be_crafted = false
			return
	
	for key in item_recipe_resource.input.keys():
		var amount = item_recipe_resource.input[key]
		inventory.remove_item(key, amount)
	
	var item_resource: ItemResource = item_recipe_resource.output
	inventory.add_item(item_resource.name, item_resource, 1)
	
	inventory_changed.emit(item_resource)

func has_item(item_name: String) -> bool:
	return inventory.items.has(item_name)
