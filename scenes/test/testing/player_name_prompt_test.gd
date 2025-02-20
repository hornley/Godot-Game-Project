extends Node2D

var player_name_prompt_path = preload("res://scenes/ui/player_name_prompt.tscn")
@onready var player: Player = $Player

func _player_name_prompt() -> void:
	var player_name_prompt_instance = player_name_prompt_path.instantiate() as CanvasLayer
	get_tree().root.add_child(player_name_prompt_instance)
	player.disable_input_events = true
	await player_name_prompt_instance.player_name_prompt_finished
