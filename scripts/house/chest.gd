extends StaticBody2D

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var is_open: bool = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	animated_sprite.play("open")
	is_open = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	animated_sprite.play("close")
	is_open = false


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		print("Chest Opened!")


func _on_area_2d_mouse_entered() -> void:
	if is_open:
		Input.set_custom_mouse_cursor(Cursors.cursors["open"])


func _on_area_2d_mouse_exited() -> void:
		Input.set_custom_mouse_cursor(Cursors.cursors["default"])
