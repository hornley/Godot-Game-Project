extends Control

var is_open: bool = false
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready() -> void:
	update()

func update() -> void:
	for key in InventoryManager.inventory:
		var value = InventoryManager.inventory[key]
		var index = value["Index"]
		slots[index].update(value["ItemResource"], value["Amount"])

func open():
	update()
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false
