extends PanelContainer

@export var max_size: Vector2 = Vector2(300, 100) # Set max width and height

func _ready():
	var label = $Label
	label.autowrap_mode = TextServer.AUTOWRAP_WORD # Enable word wrapping
	size = label.size # Adjust to the label
	size = size.clamp(Vector2.ZERO, max_size) # Apply max size limit
