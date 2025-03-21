extends Node

var game_version: String = "v0.3.1-alpha"

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var main_scene_path: String = "res://scenes/main_scene.tscn"
var main_scene_root_path: String = "/root/MainScene"
var main_scene_world_root_path: String = "/root/MainScene/GameRoot/Worlds"
var allow_save_game: bool

var auto_save: bool
var auto_save_interval = 5 * 60 # 60 = 1min

var game_screen: GameScreen
var on_game_menu_screen: bool
var is_game_loaded: bool = false

var world_scenes: Dictionary = {
	Util.Worlds.Test: "res://test/TEST.tscn",
	Util.Worlds.Village : "res://scenes/world/village.tscn",
	Util.Worlds.Home : "res://scenes/world/home.tscn"
}
var current_world: Util.Worlds
var current_world_scene: Node


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()

func start_game() -> void:
	allow_save_game = true
	
	if is_game_loaded:
		return
	
	load_main_scene_container()
	if OS.has_feature("editor") or OS.has_feature("debug"):
		load_world(Util.Worlds.Test)
	else:
		load_world(Util.Worlds.Home)
	GameDataManager.load_resources_recursive("res://resources/")
	
	load_util_crop_scenes()
	load_game()
	is_game_loaded = true
	
	if auto_save:
		var auto_save_timer = Timer.new()
		auto_save_timer.wait_time = auto_save_interval
		auto_save_timer.autostart = true
		auto_save_timer.timeout.connect(on_auto_save)
		add_child(auto_save_timer)

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)
	on_game_menu_screen = true

func load_main_scene_container() -> void:
	if get_tree().root.has_node(main_scene_root_path):
		return
	
	var node: Node = load(main_scene_path).instantiate()
	
	if node != null:
		get_tree().root.add_child(node)

func load_world(world: Util.Worlds) -> void:
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
		current_world = world
		current_world_scene = world_scene

func on_auto_save() -> void:
	save_game()
	game_screen.toggle_auto_save_notification()

func save_game() -> void:
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.save_game()

func load_game() -> void:
	await get_tree().process_frame
	
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.load_game()

func load_util_crop_scenes() -> void:
	Util.crop_scenes = {
		Util.Seeds.Carrot: preload("res://scenes/objects/crops/carrot.tscn"),
		Util.Seeds.Cauliflower: preload("res://scenes/objects/crops/cauliflower.tscn"),
		Util.Seeds.Tomato: preload("res://scenes/objects/crops/tomato.tscn"),
		Util.Seeds.Eggplant: preload("res://scenes/objects/crops/eggplant.tscn"),
		Util.Seeds.Tulip: preload("res://scenes/objects/crops/tulip.tscn"),
		Util.Seeds.Cabbage: preload("res://scenes/objects/crops/cabbage.tscn"),
		Util.Seeds.Wheat: preload("res://scenes/objects/crops/wheat.tscn"),
		Util.Seeds.Pumpkin: preload("res://scenes/objects/crops/pumpkin.tscn"),
		Util.Seeds.Turnip: preload("res://scenes/objects/crops/turnip.tscn"),
		Util.Seeds.BigFlower: preload("res://scenes/objects/crops/big_flower.tscn"),
		Util.Seeds.Starfruit: preload("res://scenes/objects/crops/starfruit.tscn"),
		Util.Seeds.Beetroot: preload("res://scenes/objects/crops/beetroot.tscn"),
		Util.Seeds.Cucumber: preload("res://scenes/objects/crops/cucumber.tscn")
	}
