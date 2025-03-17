extends Node2D
@onready var sprite_2d: Sprite2D = $Sprite2D

func _ready() -> void:
	print(sprite_2d.get_rect())
