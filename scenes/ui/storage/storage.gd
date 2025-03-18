class_name StorageGUI extends Control

var is_open: bool = false
@onready var storage_item_stack_scene = preload("res://scenes/ui/storage/storage_item_stack.tscn")
@export var grid_container: GridContainer
@export var hotbar_gui: Control
@export var storage_controller: StorageController

var storage_component: StorageComponent
var slots: Array
var is_in_hotbar_gui: bool

func on_inventory_changed(item: ItemResource) -> void:
	update()

func load_slots() -> void:
	if grid_container.get_children().size() != storage_component.size:
		create_slots()
	connect_slots()
	update()
	connect_hotbar()

func create_slots() -> void:
	for i in range(storage_component.size):
		var storage_slot_scene: StorageSlot = preload("res://scenes/ui/storage/storage_slot.tscn").instantiate() as StorageSlot
		grid_container.add_child(storage_slot_scene)
	slots = grid_container.get_children()

func connect_hotbar() -> void:
	for slot in hotbar_gui.slots:
		if not slot.is_connected("pressed", Callable(self, "equip_on_hotbar")):
			var callable = Callable(equip_on_hotbar)
			callable = callable.bind(slot)
			slot.pressed.connect(callable)

func connect_slots() -> void:
	for slot in slots:
		if not slot.is_connected("pressed", Callable(self, "on_slot_pressed")):
			var callable = Callable(on_slot_pressed)
			callable = callable.bind(slot)
			slot.pressed.connect(callable)

func update() -> void:
	if storage_component == null or storage_component.items == null:
		return
	
	for key in storage_component.items.keys():
		var value = storage_component.items[key]
		var index = value["Index"]
		
		var storage_item_stack: StorageItemStack = slots[index].item_stack
		if !storage_item_stack:
			storage_item_stack = storage_item_stack_scene.instantiate()
			slots[index].update(storage_item_stack)
		
		storage_item_stack.update(value["ItemResource"], value["Amount"])
	
	for slot in slots:
		var item_resource: ItemResource = slot.get_item_resource()
		if item_resource and storage_component.items.has(item_resource.name):
			var value = storage_component.items[item_resource.name]
			var index = value["Index"]
			
			var storage_item_stack: StorageItemStack = slots[index].item_stack
			if !storage_item_stack:
				storage_item_stack = storage_item_stack_scene.instantiate()
				slots[index].update(storage_item_stack)
			
			storage_item_stack.update(value["ItemResource"], value["Amount"])
		else:
			slot.remove_item()

func open():
	update()
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func on_slot_pressed(slot: StorageSlot) -> void:
	if slot.is_empty() && storage_controller.item_in_hand: # Inserting
		insert_item_from_slot(slot)
		return
	elif !slot.is_empty() && storage_controller.item_in_hand: # Swapping/Stacking
		if storage_controller.item_in_hand.item_resource.name != slot.get_item_resource().name:
			swap_item_slots(slot)
		else:
			stack_item(slot)
		return
	
	if !storage_controller.item_in_hand: # Taking
		take_item_from_slot(slot)

func take_item_from_slot(slot: StorageSlot):
	storage_controller.item_in_hand = slot.take_item()
	if storage_controller.item_in_hand:
		if storage_controller.item_in_hand.get_parent():
			storage_controller.item_in_hand.get_parent().remove_child(storage_controller.item_in_hand)
		add_child(storage_controller.item_in_hand)
		update_item_in_hand()

func insert_item_from_slot(slot: StorageSlot):
	var item = storage_controller.item_in_hand
	var update_slot: bool = true
	
	var item_parent = item.get_parent()
	var slot_parent = slot.get_parent().get_parent().get_parent()
	remove_item_in_hand()
	
	if item_parent != slot_parent:
		var item_storage_component = item_parent.storage_component
		var other_storage_component = slot_parent.storage_component
		var amount: int = item_storage_component.items[item.item_resource.name]["Amount"]
		if other_storage_component.items.has(item.item_resource.name):
			update_slot = false
		item_storage_component.transfer_item(item.item_resource, amount, slot_parent.slots.find(slot), other_storage_component)
	else:
		storage_component.move_item(item.item_resource.name, slots.find(slot))
	
	if update_slot:
		slot.update(item)

func swap_item_slots(slot: StorageSlot):
	var item = storage_controller.item_in_hand
	var to_swap_item = slot.take_item()
	
	var item_parent = item.get_parent()
	var slot_parent = slot.get_parent().get_parent().get_parent()
	remove_item_in_hand()
	
	if item_parent != slot_parent:
		var item_storage_component = item_parent.storage_component
		var other_storage_component = slot_parent.storage_component
		
		var item_index = item_storage_component.items[item.item_resource.name]["Index"]
		var to_swap_item_index = storage_component.items[to_swap_item.item_resource.name]["Index"]
		
		var item_amount: int = item_storage_component.items[item.item_resource.name]["Amount"]
		var to_swap_item_amount: int = other_storage_component.items[to_swap_item.item_resource.name]["Amount"]
		
		item_storage_component.transfer_item(item.item_resource, item_amount, to_swap_item_index, other_storage_component)
		other_storage_component.transfer_item(to_swap_item.item_resource, to_swap_item_amount, item_index, item_storage_component)
		
		item_parent.slots[item_index].update(to_swap_item)
		slot_parent.slots[to_swap_item_index].update(item)
	else:
		var item_index = storage_component.items[item.item_resource.name]["Index"]
		var new_index = storage_component.items[to_swap_item.item_resource.name]["Index"]
		slot.update(item)
		slots[item_index].update(to_swap_item)
		storage_component.swap_item(item.item_resource.name, new_index, to_swap_item.item_resource.name, item_index)

func stack_item(slot: StorageSlot):
	var item = storage_controller.item_in_hand
	var other_item = slot.take_item()
	
	var item_parent = item.get_parent()
	var slot_parent = slot.get_parent().get_parent().get_parent()
	remove_item_in_hand()
	
	if item_parent != slot_parent:
		var item_storage_component = item_parent.storage_component
		var other_storage_component = slot_parent.storage_component
		var amount: int = item_storage_component.items[item.item_resource.name]["Amount"]
		item_storage_component.transfer_item(item.item_resource, amount, slot_parent.slots.find(slot), other_storage_component)

func update_item_in_hand() -> void:
	if !storage_controller.item_in_hand: return
	
	storage_controller.item_in_hand.global_position = get_global_mouse_position() - storage_controller.item_in_hand.size / 2
	storage_controller.item_in_hand.z_index = 2

func put_item_back() -> void:
	var item = storage_controller.item_in_hand
	var index = storage_component.items[item.item_resource.name]["Index"]
	
	slots[index].update(storage_controller.item_in_hand)
	
	storage_controller.item_in_hand = null

func _input(event: InputEvent) -> void:
	if !storage_controller or !storage_component:
		return
	
	if storage_controller.item_in_hand and event.is_action_pressed("right_click"):
		put_item_back()
	
	update_item_in_hand()

func equip_on_hotbar(slot) -> void:
	if !storage_controller.item_in_hand:
		return
		
	var item = storage_controller.item_in_hand
	var index = hotbar_gui.slots.find(slot)
	put_item_back()
	HotbarManager.insert_to_hotbar(index, item.item_resource)

func remove_item_in_hand():
	if storage_controller.item_in_hand.get_parent() != self:
		storage_controller.item_in_hand.get_parent().remove_child(storage_controller.item_in_hand)
	else:
		remove_child(storage_controller.item_in_hand)
	storage_controller.item_in_hand = null
