class_name SaveDataComponent
extends Node

@onready var parent_node: Node2D = get_parent() as Node2D

@export var save_data_resource: Resource

func _ready() -> void:
	if parent_node.name == "Player":
		if parent_node.get_parent().name == "SaveGameMenuScreenBackground":
			return
		add_to_group("player_save_data_component")
	else:
		add_to_group("save_data_component")


func _save_data() -> Resource:
	if parent_node == null:
		return null
	
	if save_data_resource == null:
		push_error("save_data_resource:", save_data_resource, parent_node.name)
		return null
	
	save_data_resource._save_data(parent_node)
	
	return save_data_resource
