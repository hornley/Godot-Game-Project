extends Node2D

@export_enum("Broken", "Normal") var state: String = "Broken"

@onready var sprite_2d: Sprite2D = $Sprite2D


func _ready() -> void:
	if state == "Broken":
		sprite_2d.texture.region = Rect2(0, 0, 108, 106)
	else:
		sprite_2d.texture.region = Rect2(145, 0, 107, 106)
