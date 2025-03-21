extends Resource
class_name QuestResource

@export var title: String
@export var description: String
@export var rewards: Dictionary = {}
@export var next_quest: String

@export var quest_source: String
@export var quest_dialogue_name: String

@export var prerequisites: Array[String] = []  # Titles of quests required before starting
@export var required_items: Dictionary = {}  # { "item_name": quantity } required to complete
@export var required_actions: Dictionary = {}  # { "action": amount } required to complete
@export var turn_in_required: bool = false  # Player must talk to NPC to finish quest
