class_name CropsCursorComponent
extends Node

@export var tilled_soil_tilemap_layer: TileMapLayer
#@export var field_cursor_component: FieldCursorComponent

@onready var player: Player

var corn_plant_scene = preload("res://scenes/objects/plants/corn.tscn")
var tomato_plant_scene = preload("res://scenes/objects/plants/tomato.tscn")

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
		if ToolManager.selected_tool == DataTypes.Tools.PlantCorn or ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
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
	
	if ToolManager.selected_tool == DataTypes.Tools.PlantCorn:
		var corn_instance = corn_plant_scene.instantiate() as Node2D
		corn_instance.global_position = local_cell_position
		get_parent().find_child("CropFields").add_child(corn_instance)
	
	if ToolManager.selected_tool == DataTypes.Tools.PlantTomato:
		var tomato_instance = tomato_plant_scene.instantiate() as Node2D
		tomato_instance.global_position = local_cell_position
		get_parent().find_child("CropFields").add_child(tomato_instance)
