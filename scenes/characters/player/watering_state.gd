extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D
@export var hit_component_collision_shape: CollisionShape2D


func _ready() -> void:
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0, 0)

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	if !animated_sprite.is_playing():
		transition.emit("Idle")


func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite.play("watering_back")
		hit_component_collision_shape.position = Vector2(0, -18)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite.play("watering_front")
		hit_component_collision_shape.position = Vector2(0, 10)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite.play("watering_left")
		hit_component_collision_shape.position = Vector2(-19, -2)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite.play("watering_right")
		hit_component_collision_shape.position = Vector2(19, -2)
	else:
		animated_sprite.play("watering_front")
		
	hit_component_collision_shape.disabled = false


func _on_exit() -> void:
	hit_component_collision_shape.disabled = true
	GameInputEvents.tool_to_transition_into = Util.Tools.None
