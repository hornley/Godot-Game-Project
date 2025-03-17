class_name CursorComponent
extends Node

@export var land_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var undergrowth_tilemap_layer: TileMapLayer
@export var overgrowth_tilemap_layer: TileMapLayer

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float

var player: Player

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func get_cell_under_mouse() -> bool:
	# Undergrowth Tilemap
	mouse_position = undergrowth_tilemap_layer.get_local_mouse_position()
	cell_position = undergrowth_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = undergrowth_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = undergrowth_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	if cell_source_id != -1:
		return false
	
	# Grass Tilemap
	mouse_position = land_tilemap_layer.get_local_mouse_position()
	cell_position = land_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = land_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = land_tilemap_layer.map_to_local(cell_position)
	
	return true

func get_direction_player_to_cell(cell_pos: Vector2i) -> Vector2i:
	var diff = cell_pos - land_tilemap_layer.local_to_map(land_tilemap_layer.to_local(player.global_position))
	return diff
