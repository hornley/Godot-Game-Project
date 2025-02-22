extends Node

var player: Player
var player_name: String
var coins: int

var inventory: Dictionary
var completed_quests: Array
var active_quests: Array

signal player_name_changed
signal player_coin_add

func set_player(_player: Player) -> void:
	player = _player

func change_player_name(name: String) -> void:
	player_name = name
	
	player_name_changed.emit()
	
func add_coin(amount: int) -> void:
	coins += amount
	
	player_coin_add.emit()

func toggle_player_movement() -> void:
	player.disable_input_events = !player.disable_input_events

func _player_name_prompt() -> void:
	var player_name_prompt_path = preload("res://scenes/ui/player_name_prompt.tscn")
	var player_name_prompt_instance = player_name_prompt_path.instantiate() as CanvasLayer
	get_parent().add_child(player_name_prompt_instance)
	player.disable_input_events = true
	await player_name_prompt_instance.player_name_prompt_finished
