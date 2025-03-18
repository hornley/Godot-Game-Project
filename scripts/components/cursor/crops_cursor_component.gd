class_name CropsCursorComponent
extends CursorComponent

@export var cropfields: Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		if HotbarManager.equipped_item != null and HotbarManager.equipped_item_category == Util.ItemCategories.Seeds:
			get_cell_under_mouse()
			add_crop()

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
	mouse_position = tilled_soil_tilemap_layer.get_local_mouse_position()
	cell_position = tilled_soil_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = tilled_soil_tilemap_layer.map_to_local(cell_position)
	
	return true

func add_crop() -> void:
	if cell_position in cropfields.crops.keys() or cell_source_id != 2:
		return
	
	var equipped_item_name: String = HotbarManager.equipped_item_name
	var equipped_item: Util.Seeds = HotbarManager.equipped_item
	
	if distance >= 20:
		if !await land_tilemap_layer.path_find(cell_position, false):
			return
	
	#if field_cursor_component.tilemap[cell_position]["Hits"] / 2 != 5:
		#return
	
	var crop_instance: Crop
	
	crop_instance = Util.crop_scenes[equipped_item].instantiate() as Crop
	
	if crop_instance:
		PlayerManager.remove_item(equipped_item_name, 1)
		crop_instance.global_position = local_cell_position
		crop_instance.crop_name = crop_instance.name
		cropfields.crops[cell_position] = crop_instance
		cropfields.add_child(crop_instance)
