class_name CropsCursorComponent
extends CursorComponent

@export var cropfields: Node2D

var crops: Array = []

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		if HotbarManager.equipped_item != null and HotbarManager.equipped_item_category == Util.ItemCategories.Seeds:
			get_cell_under_mouse()
			add_crop()

func add_crop() -> void:
	if cell_position in crops or cell_source_id == -1:
		return
	
	if distance >= 20:
		if !await land_tilemap_layer.path_find(cell_position, false):
			return
	
	#if field_cursor_component.tilemap[cell_position]["Hits"] / 2 != 5:
		#return
	
	var crop_instance: Node2D
	
	crop_instance = Util.crop_scenes[HotbarManager.equipped_item].instantiate() as Node2D
	
	if crop_instance:
		PlayerManager.remove_item(HotbarManager.equipped_item_name, 1)
		crop_instance.global_position = local_cell_position
		crop_instance.crop_name = crop_instance.name
		crops.append(cell_position)
		cropfields.add_child(crop_instance)
