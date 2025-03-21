class_name ActiveQuestUI
extends Control

@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var separator_1: PanelContainer = $PanelContainer/VBoxContainer/Separator1
@onready var description: Label = $PanelContainer/VBoxContainer/Description
@onready var separator_2: PanelContainer = $PanelContainer/VBoxContainer/Separator2
@onready var condition: Label = $PanelContainer/VBoxContainer/Condition

var required_items: Dictionary

func _ready() -> void:
	PlayerManager.inventory_changed.connect(update_condition)

func update(quest: QuestResource) -> void:
	title.text = quest.title
	description.text = quest.description
	
	if quest.required_items.is_empty():
		separator_2.visible = false
		condition.visible = false
		return
	separator_2.visible = true
	condition.visible = true
	
	required_items = quest.required_items
	update_condition(null)

func update_condition(_item: ItemResource) -> void:
	condition.text = ""
	for item in required_items:
		var amount = required_items[item]
		var current_amount = PlayerManager.get_item_amount(item)
		condition.text += str(item) + " " + str(current_amount) + "/" + str(amount) + "\n"
