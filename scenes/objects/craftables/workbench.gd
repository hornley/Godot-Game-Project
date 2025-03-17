extends InteractableObject


func _unhandled_input(event: InputEvent) -> void:
	if !is_placed:
		return
	
	if in_range and event.is_action_pressed("interact"):
		GameManager.game_screen.toggle_crafting()
