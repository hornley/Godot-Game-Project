extends CanvasLayer

@onready var inventory_gui: Control = $InventoryGUI
@onready var crafting_gui: Control = $CraftingGUI

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_backpack"):
		if inventory_gui.is_open:
			inventory_gui.close()
			get_tree().paused = false
		else:
			inventory_gui.open()
			get_tree().paused = true
	if event.is_action_pressed("toggle_crafting"):
		if crafting_gui.is_open:
			crafting_gui.close()
			get_tree().paused = false
		else:
			crafting_gui.open()
			get_tree().paused = true
