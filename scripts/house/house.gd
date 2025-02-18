extends Node2D

@onready var house: Node2D = $"."
@export var player_detect: Area2D
@export var door: StaticBody2D
@export var roof: TileMapLayer

var is_player_inside: bool

func fade_out(duration):
	var tween = create_tween()
	tween.tween_property(roof, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func fade_in(duration):  # For fading back in
		var tween = create_tween()
		tween.tween_property(roof, "modulate:a", 1.0, duration).set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN_OUT)


func _process(delta: float) -> void:
	if door.is_door_open:
		fade_out(0.5)
	elif door.is_door_open == false and is_player_inside == false:
		fade_in(0.5)


func _on_player_detect_body_entered(body: Node2D) -> void:
	is_player_inside = true


func _on_player_detect_body_exited(body: Node2D) -> void:
	is_player_inside = false
