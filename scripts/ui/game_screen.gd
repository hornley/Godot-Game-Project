class_name GameScreen
extends CanvasLayer

var inventory_gui: Control
var crafting_gui: Control
var storage_gui: Control
var auto_save_notification: Control
var hud_message_ui: HUDMessageUI
var active_quest_ui: ActiveQuestUI

func _ready() -> void:
	inventory_gui = $HBoxContainer/InventoryGUI
	crafting_gui = $CraftingGUI
	storage_gui = $HBoxContainer/StorageGUI
	auto_save_notification = $AutoSaveNotification
	hud_message_ui = $HUDMessageUI
	active_quest_ui = $ActiveQuestUI
	GameManager.game_screen = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_backpack"):
		toggle_backpack()
	if event.is_action_pressed("toggle_crafting"):
		toggle_crafting()

func toggle_backpack() -> void:
	crafting_gui.close()
	if inventory_gui.is_open and !storage_gui.is_open:
		inventory_gui.close()
		get_tree().paused = false
	else:
		inventory_gui.open()
		get_tree().paused = true
	storage_gui.close()

func toggle_crafting() -> void:
	inventory_gui.close()
	storage_gui.close()
	if crafting_gui.is_open:
		crafting_gui.close()
		get_tree().paused = false
	else:
		crafting_gui.open(Util.CraftingStations.None)
		get_tree().paused = true

func toggle_storage(_storage_component: StorageComponent) -> void:
	crafting_gui.close()
	storage_gui.initialize_storage(_storage_component)
	if storage_gui.is_open:
		storage_gui.close()
		inventory_gui.close()
		get_tree().paused = false
	else:
		inventory_gui.open()
		storage_gui.open()
		get_tree().paused = true

func toggle_auto_save_notification() -> void:
	auto_save_notification.visible = true
	await get_tree().create_timer(3).timeout
	auto_save_notification.visible = false

func update_active_quest_ui(quest: QuestResource) -> void:
	active_quest_ui.update(quest)
