extends Control

var is_open: bool = false
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
@onready var inventory_item_stack_scene = preload("res://scenes/ui/inventory/inventory_item_stack.tscn")
@onready var hotbar_gui: Control = $"../MarginContainer/HotbarGUI"

var item_in_hand: InventoryItemStack
var is_in_hotbar_gui: bool

func _ready() -> void:
	connect_slots()
	update()
	connect_hotbar()

func connect_hotbar() -> void:
	for slot in hotbar_gui.slots:
		var callable = Callable(equip_on_hotbar)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func connect_slots() -> void:
	for slot in slots:
		var callable = Callable(on_slot_pressed)
		callable = callable.bind(slot)
		slot.pressed.connect(callable)

func update() -> void:
	for key in InventoryManager.inventory:
		var value = InventoryManager.inventory[key]
		var index = value["Index"]
		
		var inventory_item_stack: InventoryItemStack = slots[index].item_stack
		if !inventory_item_stack:
			inventory_item_stack = inventory_item_stack_scene.instantiate()
			slots[index].update(inventory_item_stack)
		
		inventory_item_stack.update(value["ItemResource"], value["Amount"])

func open():
	update()
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func on_slot_pressed(slot) -> void:
	if slot.is_empty() && item_in_hand: # Inserting
		insert_item_from_slot(slot)
		return
	elif !slot.is_empty() && item_in_hand: # Swapping
		swap_item_slots(slot)
		return
	
	if !item_in_hand: # Taking
		take_item_from_slot(slot)

func take_item_from_slot(slot):
	item_in_hand = slot.take_item()
	if item_in_hand:
		add_child(item_in_hand)
		update_item_in_hand()

func insert_item_from_slot(slot):
	var item = item_in_hand
	var index = slots.find(slot)
	
	remove_child(item_in_hand)
	item_in_hand = null
	InventoryManager.move_item(item.item_resource.name, index)
	
	slot.update(item)

func swap_item_slots(slot):
	var item = item_in_hand
	var to_swap_item = slot.take_item()
	var old_index = InventoryManager.inventory[item.item_resource.name]["Index"]
	var new_index = InventoryManager.inventory[to_swap_item.item_resource.name]["Index"]
	
	remove_child(item_in_hand)
	item_in_hand = null
	InventoryManager.swap_item(item.item_resource.name, new_index, to_swap_item.item_resource.name, old_index)
	
	slot.update(item)
	slots[old_index].update(to_swap_item)

func update_item_in_hand() -> void:
	if !item_in_hand: return
	
	item_in_hand.global_position = get_global_mouse_position() - item_in_hand.size / 2

func put_item_back() -> void:
	var item = item_in_hand
	var index = InventoryManager.inventory[item.item_resource.name]["Index"]
	
	remove_child(item_in_hand)
	item_in_hand = null
	
	slots[index].update(item)

func _input(event: InputEvent) -> void:
	if item_in_hand and event.is_action_pressed("right_click"):
		put_item_back()
	
	update_item_in_hand()

func equip_on_hotbar(slot) -> void:
	if !item_in_hand:
		return
		
	var item = item_in_hand
	var index = hotbar_gui.slots.find(slot)
	put_item_back()
	HotbarManager.insert_to_hotbar(index, item.item_resource)
	slot.update(item.item_resource.texture)
