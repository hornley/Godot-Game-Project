class_name HUDMessageUI
extends Control

@onready var label: Label = $PanelContainer/Label

func set_text(_text: String) -> void:
	label.text = _text
