extends CanvasLayer

@onready var line_edit: LineEdit = $MarginContainer/VBoxContainer/LineEdit

signal player_name_prompt_finished

func _on_button_pressed() -> void:
	if line_edit.text.length() > 0:
		PlayerManager.player.player_name = line_edit.text
		player_name_prompt_finished.emit()
		queue_free()
