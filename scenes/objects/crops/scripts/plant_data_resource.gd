class_name PlantDataResource
extends SceneDataResource

@export var current_growth_state: Util.GrowthStates
@export var days_until_harvest: int
@export var is_watered: bool
@export var starting_day: int
@export var current_day: int


func _save_data(node: Node2D) -> void:
	super._save_data(node)
	
	var GrowthCycleComponentNode = node.find_child("GrowthCycleComponent") as GrowthCycleComponent
	
	current_growth_state = GrowthCycleComponentNode.current_growth_state
	days_until_harvest = GrowthCycleComponentNode.days_until_harvest
	is_watered = GrowthCycleComponentNode.is_watered
	starting_day = GrowthCycleComponentNode.starting_day
	current_day = GrowthCycleComponentNode.current_day

func _load_data(window) -> void:
	var parent_node: Node2D
	var scene_node: Node2D
	
	if parent_node_path != null:
		parent_node = window.get_node_or_null(parent_node_path)
	
	if node_path != null:
		var scene_file_resource: Resource = load(scene_file_path)
		scene_node = scene_file_resource.instantiate() as Node2D
	
	if parent_node != null and scene_node != null:
		var GrowthCycleComponentNode = scene_node.find_child("GrowthCycleComponent") as GrowthCycleComponent
		
		GrowthCycleComponentNode.current_growth_state = current_growth_state
		GrowthCycleComponentNode.days_until_harvest = days_until_harvest
		GrowthCycleComponentNode.is_watered = is_watered
		GrowthCycleComponentNode.starting_day = starting_day
		GrowthCycleComponentNode.current_day = current_day
		scene_node.global_position = global_position
		parent_node.add_child(scene_node)
