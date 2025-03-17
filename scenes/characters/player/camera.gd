extends Camera2D

func _process(delta):
	position = position.round()  # Snap to whole pixels
