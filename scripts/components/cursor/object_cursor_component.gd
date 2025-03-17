class_name ObjectCursorComponent
extends CursorComponent

const WORKBENCH = preload("res://scenes/objects/craftables/workbench.tscn")

@export var objects_tilemap_layer: TileMapLayer

var object_instance: InteractableObject

func _ready() -> void:
	super._ready()
	HotbarManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: Util.Tools) -> void:
	if tool == Util.Tools.None and object_instance != null and !object_instance.is_placed:
		if object_instance.get_parent():
			objects_tilemap_layer.remove_child(object_instance)
	
	if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
		set_object_instance()

func _input(event: InputEvent) -> void:
	if !object_instance:
		return
	
	if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
		var is_clear = get_cell_under_mouse()
		update_object(is_clear)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
			object_instance.place()
			update_astargrid_solid_cells()
			PlayerManager.remove_item(HotbarManager.equipped_item_name, 1)
			if !HotbarManager.equipped_item_name or !PlayerManager.has_item(HotbarManager.equipped_item_name):
				object_instance = null
			else:
				set_object_instance()

func object_overview() -> void:
	pass

func update_object(can_place: bool) -> void:
	if cell_source_id == -1 or distance > 100:
		return
	
	if object_instance:
		object_instance.global_position = local_cell_position
	
	if can_place:
		object_instance.modulate = Color(1.0, 1.0, 1.0, .5)
	else:
		object_instance.modulate = Color(1.0, 0.3, 0.3, .5)

func set_object_instance() -> void:
	if HotbarManager.equipped_item == Util.Objects.Workbench:
		object_instance = WORKBENCH.instantiate() as Node2D
	
	if object_instance:
		object_instance.modulate.a = 0.5
	
	objects_tilemap_layer.add_child(object_instance)

func update_astargrid_solid_cells() -> void:
	land_tilemap_layer.astargrid2d.set_point_solid(cell_position)
	
	if HotbarManager.equipped_item_name == "Workbench":
		land_tilemap_layer.astargrid2d.set_point_solid(cell_position + Vector2i(1, 0))
		land_tilemap_layer.astargrid2d.set_point_solid(cell_position - Vector2i(1, 0))
