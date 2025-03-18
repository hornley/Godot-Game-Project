extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D

var direction: Vector2

func _ready() -> void:
	PlayerManager.player_path_find.connect(on_player_path_find)


func on_player_path_find() -> void:
	transition.emit("Move")


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
	
	var tool_to_transition_into = GameInputEvents.tool_to_transition_into
	if tool_to_transition_into != Util.Tools.None:
		if tool_to_transition_into == Util.Tools.Axe:
			transition.emit("Chopping")
		elif tool_to_transition_into == Util.Tools.Hoe:
			transition.emit("Tilling")
		elif tool_to_transition_into == Util.Tools.Pickaxe:
			transition.emit("Mining")
		elif tool_to_transition_into == Util.Tools.WateringCan:
			transition.emit("Watering")
	elif GameInputEvents.use_tool() or Input.is_action_just_pressed("use_item"):
		if player.current_tool == Util.Tools.Axe:
			transition.emit("Chopping")
		elif player.current_tool == Util.Tools.Hoe:
			transition.emit("Tilling")
		elif player.current_tool == Util.Tools.Pickaxe:
			transition.emit("Mining")
		elif player.current_tool == Util.Tools.WateringCan:
			transition.emit("Watering")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite.stop()
