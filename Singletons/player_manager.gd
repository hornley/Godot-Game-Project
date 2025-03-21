extends Node

var player: Player
var path: Array
var current_path_index: int
var coins: int
var inventory: StorageComponent
var completed_quests: Dictionary = {}
var active_quests: Dictionary = {}

signal inventory_changed(item: ItemResource)
signal player_loaded
signal player_coin_updated(coins: int)
signal player_path_find
signal player_path_find_finished(is_successful: bool)

func toggle_player_movement() -> void:
	player.disable_input_events = !player.disable_input_events

func add_coin(amount: int) -> void:
	coins += amount
	player_coin_updated.emit(coins)

func set_path_find(_path: Array) -> void:
	if _path.is_empty():
		return  # Prevent assigning an empty path
	clear_path()
	path = _path
	player_path_find.emit()

func clear_path() -> void:
	path.clear()
	current_path_index = 0

func _player_name_prompt() -> void:
	var player_name_prompt_path = preload("res://scenes/ui/player_name_prompt.tscn")
	var player_name_prompt_instance = player_name_prompt_path.instantiate() as CanvasLayer
	get_parent().add_child(player_name_prompt_instance)
	player.disable_input_events = true
	await player_name_prompt_instance.player_name_prompt_finished

func get_player_name() -> String:
	return player.player_name

# --------------------------
# INVENTORY SYSTEM
# --------------------------

func on_player_inventory_changed(item: ItemResource) -> void:
	inventory_changed.emit(item)

func add_item(item_name: String, amount: int) -> bool:
	return inventory.add_item(item_name, amount)

func get_item(item_name: String) -> ItemResource:
	return inventory.get_item(item_name)

func remove_item(item_name: String, amount: int) -> void:
	var item: ItemResource = inventory.remove_item(item_name, amount)
	
	if !inventory.items.has(item_name) and HotbarManager.hotbar_array.find(item) != -1:
		HotbarManager.remove_from_hotbar(HotbarManager.hotbar_array.find(item))
		HotbarManager.unequip_item()

func move_item(item_name: String, new_index: int) -> void:
	inventory.move_item(item_name, new_index)

func swap_item(item_name_1: String, item_1_new_index: int, item_name_2: String, item_2_new_index: int) -> void:
	inventory.swap_item(item_name_1, item_1_new_index, item_name_2, item_2_new_index)

func has_item(item_name: String) -> bool:
	return inventory.items.has(item_name)

func get_item_amount(item_name: String) -> int:
	if !inventory.items.has(item_name):
		return 0
	return inventory.items[item_name]["Amount"]

# --------------------------
# CRAFTING SYSTEM
# --------------------------

func craft_item(item_recipe_resource: ItemRecipeResource) -> void:
	if not item_recipe_resource:
		return  # Ensure the recipe exists before crafting
	
	#var can_be_crafted: bool = true
	for key in item_recipe_resource.input.keys():
		var amount = item_recipe_resource.input[key]
		if !inventory.items.has(key) or inventory.items[key]["Amount"] < amount:
			#can_be_crafted = false
			return
	
	for key in item_recipe_resource.input.keys():
		var amount = item_recipe_resource.input[key]
		remove_item(key, amount)
	
	inventory.add_item(item_recipe_resource.name, 1)

# --------------------------
# QUEST SYSTEM
# --------------------------

func is_quest_completed(quest_title: String) -> bool:
	return completed_quests.has(quest_title)

func add_quest(quest: QuestResource) -> bool:
	if quest.title in active_quests or quest.title in completed_quests:
		return false  # Quest already exists
	
	# Ensure all required quests are completed before adding
	for required_quest in quest.prerequisites:
		if required_quest not in completed_quests.keys():
			return false  # A prerequisite quest is missing
	
	active_quests[quest.title] = quest
	return true

func complete_quest(quest_title: String) -> void:
	var quest = active_quests[quest_title]
	
	# Move quest to completed list
	collect_rewards(quest)
	completed_quests[quest_title] = quest
	active_quests.erase(quest_title)

func collect_rewards(quest: QuestResource) -> void:
	var rewards: Dictionary = QuestManager.get_rewards(quest)
	
	for reward in rewards:
		var amount: int = rewards[reward]
		add_item(reward, amount)
