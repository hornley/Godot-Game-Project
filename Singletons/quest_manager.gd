extends Node

signal quest_completed(title: String)

func _ready():
	PlayerManager.inventory_changed.connect(_on_inventory_changed)
	EventBus.world_changed.connect(_on_world_changed)

# Called whenever the player's inventory changes
func _on_inventory_changed(item: ItemResource) -> void:
	check_quest_completion()

# Called whenever the world changes
func _on_world_changed(action: Util.Actions, data: Dictionary) -> void:
	check_quest_completion(action)

# Check if any active quests should be completed
func check_quest_completion(action: Util.Actions = Util.Actions.None) -> void:
	for quest: QuestResource in PlayerManager.active_quests.values():
		if quest.turn_in_required:
			continue
		
		if is_quest_ready_to_complete(quest, action):
			complete_quest(quest.title)

# Check if a specific quest can be completed
func is_quest_ready_to_complete(quest: QuestResource, _action: Util.Actions = Util.Actions.None) -> bool:
	if quest.required_items.is_empty() and quest.required_actions.is_empty():
		return false  # If the quest has no requirements, do nothing
	
	for item_name in quest.required_items.keys():
		var required_amount = quest.required_items[item_name]
		if not PlayerManager.has_item(item_name) or PlayerManager.inventory.items[item_name]["Amount"] < required_amount:
			return false  # Missing required items
	
	for action in quest.required_actions:
		if action in Util.actions_equivalent.keys():
			if Util.actions_equivalent[action] == _action:
				quest.required_actions[action]["Current"] += 1
			if quest.required_actions[action]["Current"] < quest.required_actions[action]["Required"]:
				return false

	return true  # Player has all required items

func get_rewards(quest: QuestResource) -> Dictionary:
	var quest_rewards: Dictionary = quest.rewards
	if quest_rewards.is_empty():
		return {}
	
	var rewards: Dictionary = {}
	for reward in quest_rewards:
		var reward_amount = quest_rewards.get(reward)
		
		# Item Reward
		if GameDataManager.is_item(reward):
			rewards[reward] = reward_amount
	
	return rewards

func complete_quest(quest_title: String) -> void:
	if quest_title not in PlayerManager.active_quests:
		return
	
	PlayerManager.complete_quest(quest_title)
	quest_completed.emit(quest_title)
	
	var next_quest_title: String = GameDataManager.get_quest(quest_title).next_quest
	if next_quest_title != "":
		var next_quest: QuestResource = GameDataManager.get_quest(next_quest_title)
		if next_quest:
			for action in next_quest.required_actions.keys():
				next_quest.required_actions[action]["Current"] = 0
			PlayerManager.add_quest(next_quest)
			GameManager.game_screen.update_active_quest_ui(next_quest)
	else:
		GameManager.game_screen.update_active_quest_ui(null)
