extends Node

var hotbar_array: Array[ItemResource] = []
var equipped_item = null
var equipped_item_name = null
var equipped_item_category = null

signal tool_selected(tool: Util.Tools)
signal hotbar_changed(index: int)

func _ready() -> void:
	hotbar_array.resize(5)
	hotbar_array.fill(null)

func get_empty_slot() -> int:
	for slot in hotbar_array:
		if slot == null:
			return hotbar_array.find(slot)
	return -1

func select_tool(tool: Util.Tools) -> void:
	tool_selected.emit(tool)
	equipped_item = tool

func insert_to_hotbar(index: int, item: ItemResource) -> void:
	hotbar_array[index] = item
	hotbar_changed.emit(index)

func remove_from_hotbar(index: int) -> void:
	hotbar_array[index] = null
	hotbar_changed.emit(index)

func equip_item(index: int) -> bool:
	if !hotbar_array[index]:
		return false
	var item = hotbar_array[index]
	print("Hotbar: " + item.name)
	
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
		equipped_item_name = item.name
		equipped_item_category = Util.ItemCategories.Tool
		tool_selected.emit(tool)
	elif item.category == Util.ItemCategories.Seeds:
		var seed: Util.Seeds
		match item.name:
			"Corn Seed":
				seed = Util.Seeds.Corn
			"Carrot Seed":
				seed = Util.Seeds.Carrot
			"Cauliflower Seed":
				seed = Util.Seeds.Cauliflower
			"Tomato Seed":
				seed = Util.Seeds.Tomato
			"Eggplant Seed":
				seed = Util.Seeds.Eggplant
			"Tulip Seed":
				seed = Util.Seeds.Tulip
			"Cabbage Seed":
				seed = Util.Seeds.Cabbage
			"Wheat Seed":
				seed = Util.Seeds.Wheat
			"Pumpkin Seed":
				seed = Util.Seeds.Pumpkin
			"Turnip Seed":
				seed = Util.Seeds.Turnip
			"Big Flower Seed":
				seed = Util.Seeds.BigFlower
			"Beetroot Seed":
				seed = Util.Seeds.Beetroot
			"Starfruit Seed":
				seed = Util.Seeds.Starfruit
			"Cucumber Seed":
				seed = Util.Seeds.Cucumber
		equipped_item = seed
		equipped_item_name = item.name
		equipped_item_category = Util.ItemCategories.Seeds
		tool_selected.emit(Util.Tools.None)
	elif item.category == Util.ItemCategories.Objects:
		var object: Util.Objects
		match item.name:
			"Workbench":
				object = Util.Objects.Workbench
		equipped_item = object
		equipped_item_name = item.name
		equipped_item_category = Util.ItemCategories.Objects
		tool_selected.emit(Util.Tools.None)
	else:
		return false
	
	return true

func unequip_item() -> void:
	equipped_item = null
	equipped_item_name = null
	equipped_item_category = null
	tool_selected.emit(Util.Tools.None)
