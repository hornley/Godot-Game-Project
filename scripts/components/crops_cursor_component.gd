class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
#@export var field_cursor_component: FieldCursorComponent

@onready var player: Player

#var corn_plant_scene = preload("res://scenes/objects/crops/corn.tscn")
var carrot_plant_scene = preload("res://scenes/objects/crops/carrot.tscn")
var cauliflower_plant_scene = preload("res://scenes/objects/crops/cauliflower.tscn")
var tomato_plant_scene = preload("res://scenes/objects/crops/tomato.tscn")
var eggplant_plant_scene = preload("res://scenes/objects/crops/eggplant.tscn")
var tulip_plant_scene = preload("res://scenes/objects/crops/tulip.tscn")
var cabbage_plant_scene = preload("res://scenes/objects/crops/cabbage.tscn")
var wheat_plant_scene = preload("res://scenes/objects/crops/wheat.tscn")
var pumpkin_plant_scene = preload("res://scenes/objects/crops/pumpkin.tscn")
var turnip_plant_scene = preload("res://scenes/objects/crops/turnip.tscn")
var big_flower_plant_scene = preload("res://scenes/objects/crops/big_flower.tscn")
var starfruit_plant_scene = preload("res://scenes/objects/crops/starfruit.tscn")
var beetroot_plant_scene = preload("res://scenes/objects/crops/beetroot.tscn")
var cucumber_plant_scene = preload("res://scenes/objects/crops/cucumber.tscn")

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		if HotbarManager.equipped_item != null and HotbarManager.equipped_item_category == Util.ItemCategories.Seeds:
			get_cell_under_mouse()
			add_crop()


func get_cell_under_mouse() -> void:
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)

func add_crop() -> void:
	if cell_source_id == -1 or distance > 20:
		return
		
	#if field_cursor_component.tilemap[cell_position]["Hits"] / 2 != 5:
		#return
	
	var crop_instance: Node2D
	
	#if HotbarManager.equipped_item == Util.Seeds.Corn:
		#crop_instance = corn_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Carrot:
		crop_instance = carrot_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Cauliflower:
		crop_instance = cauliflower_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Tomato:
		crop_instance = tomato_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Eggplant:
		crop_instance = eggplant_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Tulip:
		crop_instance = tulip_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Cabbage:
		crop_instance = cabbage_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Wheat:
		crop_instance = wheat_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Pumpkin:
		crop_instance = pumpkin_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Turnip:
		crop_instance = turnip_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.BigFlower:
		crop_instance = big_flower_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Beetroot:
		crop_instance = beetroot_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Starfruit:
		crop_instance = starfruit_plant_scene.instantiate() as Node2D
	
	if HotbarManager.equipped_item == Util.Seeds.Cucumber:
		crop_instance = cucumber_plant_scene.instantiate() as Node2D
	
	if crop_instance:
		PlayerManager.remove_item(HotbarManager.equipped_item_name, 1)
		crop_instance.global_position = local_cell_position
		get_parent().find_child("CropFields").add_child(crop_instance)
