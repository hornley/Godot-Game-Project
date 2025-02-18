extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite.play("idle_up")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite.play("idle_down")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("idle_right")
	else:
		animated_sprite.play("idle_down")


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input():
		transition.emit("Move")
	
	if player.current_tool == DataTypes.Tools.Axe && GameInputEvents.use_tool():
		transition.emit("Chopping")
	elif player.current_tool == DataTypes.Tools.Hoe && GameInputEvents.use_tool():
		transition.emit("Tilling")
	elif player.current_tool == DataTypes.Tools.Pickaxe && GameInputEvents.use_tool():
		transition.emit("Mining")
	elif player.current_tool == DataTypes.Tools.WateringCan && GameInputEvents.use_tool():
		transition.emit("Watering")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite.stop()
