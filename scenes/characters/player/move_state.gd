extends NodeState

@export var player: Player
@export var animated_sprite: AnimatedSprite2D
@export var speed: int = 100

var current_target_index: int

func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	if player.disable_input_events:
		return
	
	var direction: Vector2 = GameInputEvents.movement_input().normalized()
	
	if direction.y < 0:
		animated_sprite.play("move_back")
	elif direction.y > 0:
		animated_sprite.play("move_front")
	elif direction.x < 0:
		animated_sprite.play("move_left")
	elif direction.x > 0:
		animated_sprite.play("move_right")
	
	#if direction.y < 0:
		#if direction.x == 0:
			#animated_sprite.play("north")
		#elif direction.x > 0:
			#animated_sprite.play("northeast")
		#else:
			#animated_sprite.play("northwest")
	#elif direction.y > 0:
		#if direction.x == 0:
			#animated_sprite.play("south")
		#elif direction.x > 0:
			#animated_sprite.play("southeast")
		#else:
			#animated_sprite.play("southwest")
	#elif direction.x < 0:
		#animated_sprite.play("west")
	#elif direction.x > 0:
		#animated_sprite.play("east")
	
	if direction != Vector2.ZERO:
		player.player_direction = direction
	
	player.velocity = direction * speed
	player.last_position = player.global_position
	player.move_and_slide()


func _on_next_transitions() -> void:
	if !GameInputEvents.movement_input():
		transition.emit("Idle")


func _on_enter() -> void:
	pass


func _on_exit() -> void:
	animated_sprite.stop()
