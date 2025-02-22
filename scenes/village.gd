extends Node2D

@onready var marker_2d: Marker2D = $Marker2D

func _ready() -> void:
	PlayerManager.change_player_position(marker_2d.global_position)
