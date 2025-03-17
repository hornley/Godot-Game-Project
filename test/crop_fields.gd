extends Node2D

var crops: Array[Crop] = []


func _process(delta: float) -> void:
	if !OS.has_feature("editor") or !OS.has_feature("debug"):
		return
	
	if crops.size() == 0:
		return
	
	for crop in crops:
		if !crop.growth_cycle_component.is_watered:
			crop.water()


func _on_child_entered_tree(node: Node) -> void:
	if node is Crop:
		crops.append(node as Crop)
