extends Control

@export var slots: Array

var item: ItemResource
var toggled_slot: Node

func _ready() -> void:
	HotbarManager.hotbar_changed.connect(on_hotbar_changed)
	PlayerManager.inventory_changed.connect(on_inventory_changed)
	slots = $NinePatchRect/HBoxContainer.get_children()
	var index = 1
	for slot in slots:
		slot.update_slot_number(index)
		var callable = Callable(press_equip_in_hotbar)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
		index += 1

func update() -> void:
	for index in range(5):
		var slot = slots[index]
		if HotbarManager.hotbar_array[index]:
			var item_resource: ItemResource = HotbarManager.hotbar_array[index]
			slot.update(item_resource.texture)
		else:
			if toggled_slot == slot:
				toggled_slot.change_animated_sprite_frame(0)
				toggled_slot = null
			slot.update(null)

func on_inventory_changed(item: ItemResource) -> void:
	if item:
		insert_on_hotbar(item)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		pass
	if event.is_action_pressed("hotbar_hotkey_1"):
		hotkey_equip_in_hotbar(0)
	if event.is_action_pressed("hotbar_hotkey_2"):
		hotkey_equip_in_hotbar(1)
	if event.is_action_pressed("hotbar_hotkey_3"):
		hotkey_equip_in_hotbar(2)
	if event.is_action_pressed("hotbar_hotkey_4"):
		hotkey_equip_in_hotbar(3)
	if event.is_action_pressed("hotbar_hotkey_5"):
		hotkey_equip_in_hotbar(4)

# Equip using pressing the hotbar
func press_equip_in_hotbar(slot: Node) -> void:
	equip_item(slots.find(slot))

# Equip using hotkeys
func hotkey_equip_in_hotbar(index: int) -> void:
	equip_item(index)

func on_hotbar_changed(index: int) -> void:
	update()

func equip_item(index: int) -> void:
	var slot: Button = slots[index]
	if !HotbarManager.equip_item(index):
		return
	
	if toggled_slot != slot:
		if toggled_slot:
			toggled_slot.change_animated_sprite_frame(0)
		slot.change_animated_sprite_frame(2)
		toggled_slot = slot
	else:
		HotbarManager.unequip_item()
		toggled_slot = null
		slot.change_animated_sprite_frame(0)

func insert_on_hotbar(item: ItemResource) -> void:
	var hotbar_empty_slot = HotbarManager.get_empty_slot()
	if hotbar_empty_slot == -1:
		return
	
	if item not in HotbarManager.hotbar_array:
		HotbarManager.insert_to_hotbar(hotbar_empty_slot, item)
