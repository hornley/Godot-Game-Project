class_name FeedComponent
extends Area2D

signal crop_received(area: Area2D)


func _on_area_entered(area: Area2D) -> void:
	crop_received.emit(area)
