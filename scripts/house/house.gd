extends Node2D

@export var size: Vector2

@onready var house: Node2D = $"."
@onready var player_detect: Area2D = $PlayerDetect
@onready var door: StaticBody2D = $Objects/InteractableObjects/Door
@onready var floor: TileMapLayer = $Objects/Floor
@onready var roof: TileMapLayer = $Objects/Roof

var is_player_inside: bool

func _ready() -> void:
	size = floor.get_used_rect().size

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
