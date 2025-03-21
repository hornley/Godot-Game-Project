class_name ActiveQuestUI
extends Control

@onready var quest_title: Label = $PanelContainer/VBoxContainer/QuestTitle
@onready var quest_description: Label = $PanelContainer/VBoxContainer/QuestDescription
@onready var quest_condition: Label = $PanelContainer/VBoxContainer/QuestCondition
@onready var separator_1: PanelContainer = $PanelContainer/VBoxContainer/Separator1
@onready var separator_2: PanelContainer = $PanelContainer/VBoxContainer/Separator2

func update(quest: QuestResource) -> void:
	if !quest:
		return
	
	quest_title.text = quest.title
	quest_description.text = quest.description
	
	if quest.required_items.is_empty():
		separator_2.visible = false
		quest_condition.visible = false
		return
	else:
		separator_2.visible = true
		quest_condition.visible = true
	
	quest_condition.text = ""
	for required_item in quest.required_items:
		var amount = quest.required_items[required_item]
		var current_amount = PlayerManager.get_item_amount(required_item)
		quest_condition.text += str(required_item) + " " + str(current_amount) + "/" + str(amount) + "\n"
