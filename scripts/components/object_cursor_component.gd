class_name ObjectCursorComponent
extends Node

const WORKBENCH = preload("res://scenes/objects/craftables/workbench.tscn")

@export var objects_tilemap_layer: TileMapLayer
@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var undergrowth_tilemap_layer: TileMapLayer
@export var overgrowth_tilemap_layer: TileMapLayer

@onready var player: Player

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
		if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
			var is_clear = get_cell_under_mouse()
			if is_clear:
				add_object()

func get_cell_under_mouse() -> bool:
	# Undergrowth Tilemap
	mouse_position = undergrowth_tilemap_layer.get_local_mouse_position()
	cell_position = undergrowth_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = undergrowth_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = undergrowth_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	if cell_source_id == 0:
		return false
	
	# Grass Tilemap
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	return true

func add_object() -> void:
	if cell_source_id == -1 or distance > 100:
		return
	
	var object_instance: Node2D
	
	if HotbarManager.equipped_item == Util.Objects.Workbench:
		object_instance = WORKBENCH.instantiate() as Node2D
	
	if object_instance:
		PlayerManager.remove_item(HotbarManager.equipped_item_name)
		object_instance.global_position = local_cell_position
		get_parent().find_child("CropFields").add_child(object_instance)
