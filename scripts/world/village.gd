extends Node2D

@onready var marker_2d: Marker2D = $Portal/Marker2D

func _ready() -> void:
	PlayerManager.player.global_position = marker_2d.global_position
