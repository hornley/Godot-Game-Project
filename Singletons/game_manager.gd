extends Node

var game_menu_screen = preload("res://scenes/ui/game_menu_screen.tscn")
var game_data_path: String = "user://game_data"


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("game_menu"):
		show_game_menu_screen()


func start_game() -> void:
	SceneManager.load_main_scene_container()
	SceneManager.load_level("home") 
	
	GameDataManager.load_game_data(game_data_path)
	
	SaveGameManager.load_game()
	SaveGameManager.allow_save_game = true
	
	GameDataManager.save_game_data(game_data_path)

func exit_game() -> void:
	get_tree().quit()

func show_game_menu_screen() -> void:
	var game_menu_screen_instance = game_menu_screen.instantiate()
	get_tree().root.add_child(game_menu_screen_instance)
