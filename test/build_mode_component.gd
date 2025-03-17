extends Node2D

@export var land_tilemap_layer: TileMapLayer
var enabled: bool

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_build_mode"):
		enabled = !enabled
		if enabled:
			visible = true
		else:
			visible = false

func _process(delta: float) -> void:
	if enabled:
		mouse_position = land_tilemap_layer.get_local_mouse_position()
		cell_position = land_tilemap_layer.local_to_map(mouse_position)
		local_cell_position = land_tilemap_layer.map_to_local(cell_position)
		global_position = local_cell_position
