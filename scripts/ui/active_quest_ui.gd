class_name ActiveQuestUI
extends Control

@onready var title: Label = $PanelContainer/VBoxContainer/Title
@onready var separator_1: PanelContainer = $PanelContainer/VBoxContainer/Separator1
@onready var description: Label = $PanelContainer/VBoxContainer/Description
@onready var separator_2: PanelContainer = $PanelContainer/VBoxContainer/Separator2
@onready var condition: Label = $PanelContainer/VBoxContainer/Condition
@onready var v_box_container: VBoxContainer = $PanelContainer/VBoxContainer
@onready var panel_container: PanelContainer = $PanelContainer
@onready var button: Button = $Button

var quest: QuestResource

@onready var animation_player: AnimationPlayer = $AnimationPlayer
var is_open: bool = true

func _ready() -> void:
	PlayerManager.inventory_changed.connect(update_item_condition)
	EventBus.world_changed.connect(update_action_condition)

func update(_quest: QuestResource) -> void:
	if !_quest:
		toggle()
		return
	
	quest = _quest
	if !is_open:
		toggle()
	
	title.text = quest.title
	description.text = quest.description
	
	separator_2.visible = true
	condition.visible = true
	if !quest.required_actions.is_empty():
		update_action_condition(Util.Actions.None, {})
	elif !quest.required_items.is_empty():
		update_item_condition(null)
	else:
		separator_2.visible = false
		condition.visible = false
	
	update_container_and_button()

func update_item_condition(_item: ItemResource) -> void:
	condition.text = ""
	for item in quest.required_items:
		var amount = quest.required_items[item]
		var current_amount = PlayerManager.get_item_amount(item)
		condition.text += str(item) + " " + str(current_amount) + "/" + str(amount) + "\n"

func toggle() -> void:
	if animation_player.is_playing():
		return  # Prevents interrupting an ongoing animation
	
	if is_open:
		animation_player.play("closing")
	else:
		animation_player.play("opening")
	
	is_open = !is_open

func update_action_condition(action: Util.Actions, data: Dictionary) -> void:
	condition.text = ""
	for required_action in quest.required_actions:
		if required_action in Util.actions_equivalent.keys():
			var current = quest.required_actions[required_action]["Current"]
			var required = quest.required_actions[required_action]["Required"]
			condition.text += str(required_action) + " " + str(current) + "/" + str(required) + "\n"

func update_container_and_button() -> void:
	if panel_container.get_minimum_size().y > 75:
		var diff = panel_container.get_minimum_size().y - 75
		button.position = Vector2(button.position.x, 159 + diff)
	else:
		button.position = Vector2(button.position.x, 159)

func _on_button_pressed() -> void:
	toggle()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_quest"):
		toggle()


func _on_panel_container_resized() -> void:
	if panel_container:
		update_container_and_button()
