extends Control

@export var slots: Array

var item: ItemResource
var toggled_slot: Node

func _ready() -> void:
	slots = $NinePatchRect/HBoxContainer.get_children()
	update()

func update() -> void:
	var index = 1
	for slot in slots:
		slot.update_slot_number(index)
		var callable = Callable(press_equip_in_hotbar)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)
		index += 1

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

func equip_item(index: int) -> void:
	var slot: Button = slots[index]
	if HotbarManager.equip_item(index) and toggled_slot != slot:
		if toggled_slot:
			toggled_slot.change_animted_sprite_frame(0)
		slot.change_animted_sprite_frame(2)
		toggled_slot = slot
	else:
		HotbarManager.unequip_item()
		toggled_slot = null
		slot.change_animted_sprite_frame(0)
