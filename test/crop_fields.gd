extends Node2D

var crops: Dictionary = {}


func _process(delta: float) -> void:
	if !OS.has_feature("editor") or !OS.has_feature("debug"):
		return
	
	if crops.keys().size() == 0:
		return
	
	for crop_cell_pos in crops.keys():
		if !crops[crop_cell_pos]:
			crops.erase(crop_cell_pos)
			continue
		
		var crop: Crop = crops[crop_cell_pos]
		
		if !crop.growth_cycle_component.is_watered:
			crop.water()
