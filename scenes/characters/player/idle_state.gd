extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

var direction: Vector2

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite.play("idle_back")
	elif player.player_direction == Vector2.DOWN:
		animated_sprite.play("idle_front")
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("idle_left")
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("idle_right")
	else:
		animated_sprite.play("idle_front")
		animated_sprite.animation_finished


func _on_next_transitions() -> void:
	GameInputEvents.movement_input()
	
	if GameInputEvents.is_movement_input():
		transition.emit("Move")
	
	if player.current_tool == Util.Tools.Axe && GameInputEvents.use_tool():
		transition.emit("Chopping")
		player.z_index = 1
	elif player.current_tool == Util.Tools.Hoe && GameInputEvents.use_tool():
		transition.emit("Tilling")
		player.z_index = 1
	elif player.current_tool == Util.Tools.Pickaxe && GameInputEvents.use_tool():
		transition.emit("Mining")
		player.z_index = 1
	elif player.current_tool == Util.Tools.WateringCan && GameInputEvents.use_tool():
		transition.emit("Watering")
		player.z_index = 1


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite.stop()
