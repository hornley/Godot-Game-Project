extends Node2D

@onready var house: Node2D = $"."
@export var player_detect: Area2D
@export var door: StaticBody2D
@export var roof: TileMapLayer
@export var wall: TileMapLayer

var is_player_inside: bool

func fade_out(duration):
	var tween = create_tween()
	tween.tween_property(roof, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func fade_in(duration):  # For fading back in
		var tween = create_tween()
		tween.tween_property(roof, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _process(delta: float) -> void:
	if door.is_door_open or is_player_inside:
		fade_out(0.5)
	elif door.is_door_open == false and is_player_inside == false:
		fade_in(0.5)


func _on_player_detect_body_entered(body: Node2D) -> void:
	is_player_inside = true


func _on_player_detect_body_exited(body: Node2D) -> void:
	is_player_inside = false

#func get_used_cells() -> Dictionary:
	#var used_cells = wall.get_used_cells()
	#if used_cells.is_empty():
		#return {}  # No tiles found
#
	#var top_left = used_cells[0]
	#var bottom_right = used_cells[0]
#
	#for cell in used_cells:
		#if cell.x <= top_left.x and cell.y <= top_left.y:
			#top_left = cell
		#if cell.x >= bottom_right.x and cell.y >= bottom_right.y:
			#bottom_right = cell
	#
	#return {"top_left": top_left, "bottom_right": bottom_right}

func get_used_cells() -> Array[Vector2i]:
	return wall.get_used_cells()

func get_global_pos() -> Vector2:
	return global_position
