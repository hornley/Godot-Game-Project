class_name GameTileMap
extends Node2D

const TILE_OVERVIEW = preload("res://scenes/world/tile_overview.tscn")

var tile_overview: Node2D

func _ready() -> void:
	tile_overview = TILE_OVERVIEW.instantiate()
	add_child(tile_overview)
	tile_overview.visible = false

func update_tile_overview(new_pos: Vector2) -> void:
	tile_overview.global_position = new_pos

func enable_tile_overview() -> void:
	tile_overview.visible = true

func disable_tile_overview() -> void:
	tile_overview.visible = false
	global_position = Vector2(0, 0)
