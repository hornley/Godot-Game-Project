extends CursorComponent

var is_watering: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("use_item") and !is_watering:
		if HotbarManager.equipped_item == Util.Tools.WateringCan:
			get_cell_under_mouse()
			
			is_watering = true
			
			if distance >= 20:
				var path_exists = await land_tilemap_layer.path_find(cell_position, false)
				if path_exists:
					GameInputEvents.tool_to_transition_into = Util.Tools.WateringCan
				else:
					GameInputEvents.tool_to_transition_into = Util.Tools.None
					is_watering = false
					return
			
			GameInputEvents.use_tool_value = true
			water_crop()


func water_crop() -> void:
	PlayerManager.player.player_direction = get_direction_player_to_cell(cell_position)
	await player.animated_sprite.animation_finished
	is_watering = false
	GameInputEvents.use_tool_value = false
