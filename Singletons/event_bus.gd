extends Node

signal world_changed(action: Util.Actions, data: Dictionary)

signal land_tilled
signal undergrowth_weeding
signal overgrowth_clearing

func emit_world_change(action: Util.Actions, data: Dictionary = {}):
	world_changed.emit(action, data)
