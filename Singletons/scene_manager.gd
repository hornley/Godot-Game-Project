extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_world_root_path: String = "/root/MainScene/GameRoot/Worlds"

var world_scenes: Dictionary = {
	DataTypes.Worlds.Village : "res://scenes/village.tscn",
	DataTypes.Worlds.Home : "res://scenes/home.tscn"
}

func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
		return
	
	var node: Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)


func load_world(world: DataTypes.Worlds) -> void:
	var world_scene_path: String = world_scenes.get(world)
	
	if world_scene_path == null:
		return
	
	var world_scene: Node = load(world_scene_path).instantiate()
	var worlds_root: Node = get_node(main_scene_world_root_path)
	
	if worlds_root != null:
		var nodes = worlds_root.get_children()
		
		if nodes != null:
			for node: Node in nodes:
				node.visible = false
		
		await get_tree().process_frame
		
		worlds_root.add_child(world_scene)
