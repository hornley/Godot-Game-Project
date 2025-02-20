extends Node2D

@export var player: Player

func _player_name_prompt() -> void:
	var player_name_prompt_instance = player_name_prompt_path.instantiate() as CanvasLayer
	add_child(player_name_prompt_instance)
	player.disable_input_events = true
	await player_name_prompt_instance.player_name_prompt_finished
