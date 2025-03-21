class_name ActiveQuestUI
extends Control

@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var separator_1: PanelContainer = $PanelContainer/VBoxContainer/Separator1
@onready var description: Label = $PanelContainer/VBoxContainer/Description
@onready var separator_2: PanelContainer = $PanelContainer/VBoxContainer/Separator2
@onready var condition: Label = $PanelContainer/VBoxContainer/Condition
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer

var required_items: Dictionary

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = true

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

func _on_button_pressed() -> void:
	toggle()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_quest"):
		toggle()

func toggle() -> void:
	if animation_player.is_playing():
		return  # Prevents interrupting an ongoing animation
	
	if is_open:
		animation_player.play("closing")
	else:
		animation_player.play("opening")
	
	is_open = !is_open
