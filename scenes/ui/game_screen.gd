class_name GameScreen
extends CanvasLayer

var inventory_gui: Control
var crafting_gui: Control
var auto_save_notification: Control

func _ready() -> void:
	inventory_gui = $InventoryGUI
	crafting_gui = $CraftingGUI
	auto_save_notification = $AutoSaveNotification
	GameManager.game_screen = self

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_backpack"):
		if inventory_gui.is_open:
			inventory_gui.close()
			get_tree().paused = false
		else:
			crafting_gui.close()
			inventory_gui.open()
			get_tree().paused = true
	if event.is_action_pressed("toggle_crafting"):
		toggle_crafting()

func toggle_crafting() -> void:
		if crafting_gui.is_open:
			crafting_gui.close()
			get_tree().paused = false
		else:
			inventory_gui.close()
			crafting_gui.open(Util.CraftingStations.None)
			get_tree().paused = true

func toggle_auto_save_notification() -> void:
	auto_save_notification.visible = true
	await get_tree().create_timer(3).timeout
	auto_save_notification.visible = false
