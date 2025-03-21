extends CanvasLayer

@onready var save_game_button: Button = $MarginContainer/VBoxContainer/SaveGameButton
@onready var version: Label = $MarginContainer/MarginContainer2/Version

func _ready() -> void:
	version.text = GameManager.game_version
	save_game_button.disabled = !GameManager.allow_save_game
	save_game_button.focus_mode = GameManager.allow_save_game if Control.FOCUS_ALL else Control.FOCUS_NONE

func _on_start_game_button_pressed() -> void:
	GameManager.start_game()
	queue_free()

func _on_save_game_button_pressed() -> void:
	GameManager.save_game()

func _on_exit_game_button_pressed() -> void:
	GameManager.exit_game()
