extends Node

var hotbar_array: Array[ItemResource] = []
var equipped_item = null

signal tool_selected(tool: Util.Tools)
signal enable_tool(tool: Util.Tools)

func _ready() -> void:
	hotbar_array.resize(5)
	hotbar_array.fill(null)

func select_tool(tool: Util.Tools) -> void:
	tool_selected.emit(tool)
	equipped_item = tool

func enable_tool_button(tool: Util.Tools) -> void:
	enable_tool.emit(tool)

func insert_to_hotbar(index: int, item: ItemResource) -> void:
	hotbar_array.insert(index, item)

func equip_item(index: int) -> bool:
	if !hotbar_array[index]:
		return false
	var item = hotbar_array[index]
	print(item.name)
	
	if item.category == Util.ItemCategories.Tool:
		var tool: Util.Tools
		match item.name:
			"Hoe":
				tool = Util.Tools.Hoe
			"Axe":
				tool = Util.Tools.Axe
			"Watering Can":
				tool = Util.Tools.WateringCan
		equipped_item = tool
		tool_selected.emit(tool)
	elif item.category == Util.ItemCategories.Seeds:
		var seed: Util.Seeds
		match item.name:
			"Wheat Seed":
				seed = Util.Seeds.Wheat
			"Tomato Seed":
				seed = Util.Seeds.Tomato
		equipped_item = seed
		tool_selected.emit(Util.Tools.None)
	
	return true

func unequip_item() -> void:
	equipped_item = null
	tool_selected.emit(Util.Tools.None)
