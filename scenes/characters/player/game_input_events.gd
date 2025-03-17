class_name GameInputEvents

static var direction: Vector2
static var path_distance_check: float = 3
static var tool_to_transition_into: Util.Tools
static var use_tool_value: bool

static func movement_input() -> Vector2:
	direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_left"):
		direction += Vector2.LEFT
		PlayerManager.clear_path()
		PlayerManager.player_path_find_finished.emit(false)
	elif Input.is_action_pressed("move_right"):
		direction += Vector2.RIGHT
		PlayerManager.clear_path()
		PlayerManager.player_path_find_finished.emit(false)
	elif Input.is_action_pressed("move_up"):
		direction += Vector2.UP
		PlayerManager.clear_path()
		PlayerManager.player_path_find_finished.emit(false)
	elif Input.is_action_pressed("move_down"):
		direction += Vector2.DOWN
		PlayerManager.clear_path()
		PlayerManager.player_path_find_finished.emit(false)
	
	if PlayerManager.path.size() > 0:
		var current_path_index = PlayerManager.current_path_index
		var target_position = PlayerManager.path[current_path_index]
		direction = (target_position - PlayerManager.player.global_position).normalized()
		direction = Vector2(round(direction.x), round(direction.y))
		
		if PlayerManager.player.global_position.distance_to(target_position) < path_distance_check:  
			PlayerManager.current_path_index += 1
			path_distance_check = 3
			if PlayerManager.current_path_index >= PlayerManager.path.size():
				PlayerManager.clear_path()
				PlayerManager.player_path_find_finished.emit(true)
	
	return direction

static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false
	else:
		return true

static func use_tool() -> bool:
	return use_tool_value
