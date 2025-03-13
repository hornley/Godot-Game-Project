class_name TileMapLayerDataResource
extends NodeDataResource

@export var tilemap_layer_used_cells: Dictionary
@export var terrain_set: int
@export var terrain: int


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	var tilemap_layer: TileMapLayer = node as TileMapLayer 
	var cells: Array[Vector2i] = tilemap_layer.get_used_cells()
	
	for cell in cells:
		tilemap_layer_used_cells[cell] = {
			"AtlasCoords": tilemap_layer.get_cell_atlas_coords(cell),
			"SourceID": tilemap_layer.get_cell_source_id(cell)
		}

func _load_data(window: Window) -> void:
	var scene_node = window.get_node_or_null(node_path)
	
	var tilemap_layer: TileMapLayer = scene_node as TileMapLayer
	if scene_node != null and terrain_set != -1 and terrain != -1:
		tilemap_layer.set_cells_terrain_connect(tilemap_layer_used_cells.keys(), terrain_set, terrain, true) 
	elif scene_node != null:
		for cell in tilemap_layer.get_used_cells():
			if cell not in tilemap_layer_used_cells:
				tilemap_layer.erase_cell(cell)
		for used_cell in tilemap_layer_used_cells:
			if used_cell not in tilemap_layer.get_used_cells():
				var atlas_coords: Vector2i = tilemap_layer_used_cells[used_cell]["AtlasCoords"]
				var source_id: int = tilemap_layer_used_cells[used_cell]["SourceID"]
				tilemap_layer.set_cell(used_cell, source_id, atlas_coords)
