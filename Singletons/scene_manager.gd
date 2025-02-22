extends Node

var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_world_root_path: String = "/root/MainScene/GameRoot/Worlds"

var level_scenes : Dictionary = {
	"home" : "res://scenes/home.tscn"
}

func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
		return
	
	var node: Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)


func load_level(level: String) -> void:
	var scene_path: String = level_scenes.get(level)
	
	if scene_path == null:
		return
	
	var level_scene: Node = load(scene_path).instantiate()
	var world_root: Node = get_node(main_scene_world_root_path)
	
	if world_root != null:
		var nodes = world_root.get_children()
		
		if nodes != null:
			for node: Node in nodes:
				node.queue_free()
		
		await get_tree().process_frame
		
		world_root.add_child(level_scene)
