extends Resource
class_name QuestResource

@export var title: String
@export var description: String
@export var completed: bool
@export var rewards: Dictionary = {}
@export var quest_source: String
@export var quest_dialogue_name: String

@export var prerequisites: Array[String] = []  # Titles of quests required before starting
@export var required_items: Dictionary = {}  # { "item_name": quantity } required to complete
