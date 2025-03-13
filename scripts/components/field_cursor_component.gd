class_name FieldCursorComponent
extends Node

@export var grass_tilemap_layer: TileMapLayer
@export var tilled_soil_tilemap_layer: TileMapLayer
@export var undergrowth_tilemap_layer: TileMapLayer
@export var overgrowth_tilemap_layer: TileMapLayer
@export var terrain_set: int = 0
@export var terrain: int = 2

@onready var player: Player

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float
var is_tilling: bool

var till_position: Vector2i

@export var tilemap: Dictionary = Dictionary()

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")

func _process(delta: float) -> void:
	if HotbarManager.equipped_item == Util.Tools.Hoe and HotbarManager.equipped_item_category == Util.ItemCategories.Tool:
		if cell_source_id == 3:
			tilled_soil_tilemap_layer.erase_cell(cell_position)
		get_cell_under_mouse()
		tile_overview()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item") and !is_tilling:
		if HotbarManager.equipped_item == Util.Tools.Hoe and HotbarManager.equipped_item_category == Util.ItemCategories.Tool:
			var is_clear = get_cell_under_mouse()
			if is_clear:
				add_tilled_soil_cell()
			else:
				remove_undergrowth_cell()

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
	mouse_position = grass_tilemap_layer.get_local_mouse_position()
	cell_position = grass_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = grass_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = grass_tilemap_layer.map_to_local(cell_position)
	
	return true

func add_tilled_soil_cell() -> void:
	if distance < 20.0 && cell_source_id != -1:
		is_tilling = true
		till_position = cell_position
		await player.animated_sprite.animation_finished
		tilled_soil_tilemap_layer.set_cells_terrain_connect([till_position], terrain_set, terrain, true)
		is_tilling = false

func remove_undergrowth_cell() -> void:
	if distance < 20.0 && cell_source_id != -1:
		is_tilling = true
		till_position = cell_position
		await player.animated_sprite.animation_finished
		undergrowth_tilemap_layer.erase_cell(till_position)
		is_tilling = false

func tile_overview() -> void:
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	if distance < 20.0 and cell_source_id != 2 and !is_tilling:
		tilled_soil_tilemap_layer.set_cell(cell_position, 3, Vector2i(0, 0))
		cell_source_id = 3
