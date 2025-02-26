class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_user_data_path: String = "user://save_data/"
var save_file_name: String = "save_%s_game_data.tres"
var game_data_resource: SaveGameDataResource
var player_data_resource: PlayerDataResource
var player_save_file_name: String = "player_save.tres"


func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name


func save_player_data() -> void:
	var player_node = get_tree().get_first_node_in_group("player_save_data_component")
	print(player_node)
	if player_node != null and player_node is SaveDataComponent:
		var save_data_resource: NodeDataResource = player_node._save_data()
		player_data_resource = save_data_resource.duplicate()


func save_nodes_data() -> void:
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	game_data_resource = SaveGameDataResource.new()
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)


func save_game() -> void:
	if !DirAccess.dir_exists_absolute(save_user_data_path):
		DirAccess.make_dir_absolute(save_user_data_path)
	
	var level_save_file_name: String = save_file_name % level_scene_name
	
	save_nodes_data()
	save_player_data()
	
	var nodes_result: int = ResourceSaver.save(game_data_resource, save_user_data_path + level_save_file_name)
	var player_result: int = ResourceSaver.save(player_data_resource, save_user_data_path + player_save_file_name)


func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_user_data_path + level_save_file_name
	var player_save_path: String = save_user_data_path + player_save_file_name
	
	var root_node: Window = get_tree().root
	
	player_data_resource = ResourceLoader.load(player_save_path)
	
	if player_data_resource != null:
		player_data_resource._load_data(root_node)
	if player_data_resource == null:
		get_tree().root.get_child(-1).find_child("GameRoot").add_child(new_player())
	
	if !FileAccess.file_exists(save_game_path):
		return
	
	game_data_resource = ResourceLoader.load(save_game_path)
	
	if game_data_resource == null:
		return
	
	for resource in game_data_resource.save_data_nodes:
		if resource is Resource:
			if resource is NodeDataResource:
				resource._load_data(root_node)

func new_player() -> Player:
	const PLAYER = preload("res://scenes/characters/player/player.tscn")
	var player_scene = PLAYER.instantiate()
	player_scene.global_position = Vector2(600, 500)
	return player_scene
