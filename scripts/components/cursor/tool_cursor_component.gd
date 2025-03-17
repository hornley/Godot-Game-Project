class_name ToolCursorComponent
extends Node

const WORKBENCH = preload("res://scenes/objects/craftables/workbench.tscn")

@export var land_tilemap_layer: TileMapLayer
@export var objects_tilemap_layer: TileMapLayer

@onready var player: Player

var mouse_position: Vector2
var cell_position: Vector2i
var cell_source_id: int
var local_cell_position: Vector2
var distance: float
var object_instance: Node2D

func _ready() -> void:
	await get_tree().process_frame
	player = get_tree().get_first_node_in_group("player")
	HotbarManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: Util.Tools) -> void:
	if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
		set_object_instance()

func _input(event: InputEvent) -> void:
	if object_instance and HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
		var is_clear = get_cell_under_mouse()
		update_object(is_clear)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item"):
		if HotbarManager.equipped_item_category == Util.ItemCategories.Objects:
			object_instance.is_placed = true
			object_instance.modulate.a = 1
			PlayerManager.remove_item(HotbarManager.equipped_item_name, 1)
			if !HotbarManager.equipped_item_name or !PlayerManager.has_item(HotbarManager.equipped_item_name):
				object_instance = null
			else:
				set_object_instance()

func get_cell_under_mouse() -> bool:
	# Land Tilemap
	mouse_position = land_tilemap_layer.get_local_mouse_position()
	cell_position = land_tilemap_layer.local_to_map(mouse_position)
	cell_source_id = land_tilemap_layer.get_cell_source_id(cell_position)
	local_cell_position = land_tilemap_layer.map_to_local(cell_position)
	distance = player.global_position.distance_to(local_cell_position)
	
	return true

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
