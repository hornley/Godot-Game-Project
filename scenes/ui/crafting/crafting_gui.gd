extends Control

var is_open: bool = false
@onready var slots: Array = $NinePatchRect/HBoxContainer/GridContainer.get_children()
@onready var craftable_item_stack_scene = preload("res://scenes/ui/crafting/craftable_item_stack.tscn")
@onready var craft_button_scene = preload("res://scenes/ui/crafting/craft_button.tscn")
@onready var item_recipe_scene = preload("res://scenes/ui/crafting/item_recipe.tscn")
@onready var v_box_container: VBoxContainer = $NinePatchRect/HBoxContainer/PanelContainer/VBoxContainer

func _ready() -> void:
	connect_slots()

func connect_slots() -> void:
	for slot in slots:
		slot.pressed.connect(func(): on_slot_pressed(slot))

func update(crafting_station: Util.CraftingStations) -> void:
	var index: int = 0
	for item_recipe_name in GameDataManager.item_recipes.keys():
		var item_recipe: ItemRecipeResource = GameDataManager.get_item_recipe(item_recipe_name)
		
		var craftable_item_stack: CraftableItemStack = slots[index].item_stack
		if !craftable_item_stack:
			craftable_item_stack = craftable_item_stack_scene.instantiate()
			slots[index].update(craftable_item_stack)
		
		craftable_item_stack.update(item_recipe)
		index += 1

func on_slot_pressed(slot) -> void:
	if slot.is_empty():
		return
	
	for child in v_box_container.get_children():
		v_box_container.remove_child(child)
	
	var item_recipe_resource: ItemRecipeResource = slot.get_item_recipe_resource()
	var craft_button_instance: Button = craft_button_scene.instantiate()
	for key in item_recipe_resource.input.keys():
		var item_recipe_instance = item_recipe_scene.instantiate()
		v_box_container.add_child(item_recipe_instance)
		item_recipe_instance.update(key, item_recipe_resource.input[key])
	
	craft_button_instance.pressed.connect(func(): on_craft_button_pressed(item_recipe_resource))
	v_box_container.add_child(craft_button_instance)

func open(crafting_station: Util.CraftingStations):
	update(crafting_station)
	visible = true
	is_open = true

func close():
	visible = false
	is_open = false

func on_craft_button_pressed(item_recipe_resource: ItemRecipeResource) -> void:
	PlayerManager.craft_item(item_recipe_resource)
