extends Node

signal quest_completed(title: String)

#func check_quest_completion(quest_title: String, player_inventory: Dictionary):
	#var quest = GameDataManager.get_quest(quest_title)
	#if quest and quest.status == 1:
		## Check item requirements
		#for required_item in quest.required_items:
			#if required_item not in player_inventory:
				#return false  # Missing required item
		## Quest is complete
		#quest.status = 2  # Mark as completed
		#give_rewards(quest)
		#return true
	#return false

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
