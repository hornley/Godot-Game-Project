extends Node2D

func _ready() -> void:
	GameDataManager.load_resources_recursive("res://resources/items/")
