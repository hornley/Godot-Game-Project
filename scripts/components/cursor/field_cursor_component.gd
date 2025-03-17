class_name FieldCursorComponent
extends CursorComponent

@export var terrain_set: int = 0
@export var terrain: int = 2

var is_tilling: bool

var till_position: Vector2i

@export var tilemap: Dictionary = Dictionary()

func _process(delta: float) -> void:
	if HotbarManager.equipped_item == Util.Tools.Hoe:
		if cell_source_id == 3:
			tilled_soil_tilemap_layer.erase_cell(cell_position)
		get_cell_under_mouse()
		tile_overview()
	else:
		if cell_source_id == 3:
			tilled_soil_tilemap_layer.erase_cell(cell_position)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item") and !is_tilling:
		if HotbarManager.equipped_item == Util.Tools.Hoe:
			var is_clear = get_cell_under_mouse()
			
			is_tilling = true
			till_position = cell_position
			
			if distance >= 20:
				var path_exists = await land_tilemap_layer.path_find(cell_position, false)
				if path_exists:
					GameInputEvents.tool_to_transition_into = Util.Tools.Hoe
				else:
					GameInputEvents.tool_to_transition_into = Util.Tools.None
					is_tilling = false
					return
			
			GameInputEvents.use_tool_value = true
			if is_clear:
				add_tilled_soil_cell()
			else:
				remove_undergrowth_cell()


func add_tilled_soil_cell() -> void:
	PlayerManager.player.player_direction = get_direction_player_to_cell(till_position)
	await player.animated_sprite.animation_finished
	tilled_soil_tilemap_layer.set_cells_terrain_connect([till_position], terrain_set, terrain, true)
	is_tilling = false
	GameInputEvents.use_tool_value = false

func remove_undergrowth_cell() -> void:
	PlayerManager.player.player_direction = get_direction_player_to_cell(till_position)
	await player.animated_sprite.animation_finished
	undergrowth_tilemap_layer.erase_cell(till_position)
	is_tilling = false
	GameInputEvents.use_tool_value = false

func tile_overview() -> void:
	cell_source_id = tilled_soil_tilemap_layer.get_cell_source_id(cell_position)
	if cell_source_id != 2 and !is_tilling:
		tilled_soil_tilemap_layer.set_cell(cell_position, 3, Vector2i(0, 0))
		cell_source_id = 3
