extends Node

@onready var cursors = {}  # Dictionary to store cursor images
# Path: "res://assets/cursors/"

func _ready():
	cursors["default"] = load("res://assets/cursors/default.png")
	cursors["open"] = load("res://assets/cursors/open.png")
	cursors["sleep"] = load("res://assets/cursors/sleep.png")

	Input.set_custom_mouse_cursor(cursors["default"])
