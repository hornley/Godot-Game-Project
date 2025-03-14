extends InventoryGUI

const FARMER_SHOP_ITEM_GUI = preload("res://scenes/ui/farmer/farmer_shop_item_gui.tscn")

var farmer_shop_item_gui_instance: Panel
var current_item_pressed: ItemResource
var option: String
var farmer: Farmer

func _ready() -> void:
	if option == "Sell":
		storage_component = PlayerManager.inventory
	else:
		storage_component = farmer.storage_component
	PlayerManager.inventory_changed.connect(on_inventory_changed)
	super.load_slots()

func on_inventory_changed(item: ItemResource) -> void:
	if current_item_pressed and !PlayerManager.has_item(current_item_pressed.name):
		remove_item_gui_instance()
	update()

func connect_slots() -> void:
	for slot in slots:
		if not slot.is_connected("pressed", Callable(self, "on_slot_pressed")):
			var callable = Callable(on_slot_pressed)
			callable = callable.bind(slot)
			slot.pressed.connect(callable)

func on_slot_pressed(slot: StorageSlot) -> void:
	if slot.is_empty() or current_item_pressed == slot.get_item_resource():
		remove_item_gui_instance()
		return
	
	if farmer_shop_item_gui_instance:
		remove_item_gui_instance()
	
	farmer_shop_item_gui_instance = FARMER_SHOP_ITEM_GUI.instantiate()
	current_item_pressed = slot.get_item_resource()
	farmer_shop_item_gui_instance.global_position = get_global_mouse_position() + Vector2(10, 10)
	farmer_shop_item_gui_instance.option = option
	add_child(farmer_shop_item_gui_instance)
	farmer_shop_item_gui_instance.update(current_item_pressed)

func connect_hotbar() -> void:
	pass

func _on_button_pressed() -> void:
	queue_free()
	GameDialogueManager.farmer_shop_gui_close.emit()

func remove_item_gui_instance():
	if !farmer_shop_item_gui_instance:
		return
	
	var parent = farmer_shop_item_gui_instance.get_parent()
	if parent != self:
		parent.remove_child(farmer_shop_item_gui_instance)
	else:
		remove_child(farmer_shop_item_gui_instance)
	
	farmer_shop_item_gui_instance = null
	current_item_pressed = null
