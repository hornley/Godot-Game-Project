extends CharacterBody2D

const SPEED = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
var last_direction: String = "down"
@export var equipped_tool: int
var tool_animation = false

func _process(delta: float) -> void:
	if Input.is_action_pressed("toggle_hoe"):
		if equipped_tool == 2:
			equipped_tool = 0
		else:
			equipped_tool = 2


func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if not tool_animation:
		if direction.length() == 0:  # Check if *both* x and y are 0 (not moving)
			animated_sprite.play("idle_" + last_direction)
		else:  # Moving
			if abs(direction.y) > abs(direction.x):  # Prioritize vertical movement
				if direction.y > 0:
					animated_sprite.play("move_down")
					last_direction = "down"
				else:  # direction.y < 0
					animated_sprite.play("move_up")
					last_direction = "up"
			else:  # Prioritize horizontal movement, or equal
				if direction.x > 0:
					animated_sprite.play("move_right")
					last_direction = "right"
				else:  # direction.x <= 0
					animated_sprite.play("move_left")
					last_direction = "left"
	else:
		if animated_sprite.frame == 1:
			tool_animation = false

	velocity = direction * SPEED
	move_and_slide()


func hoe_animation():
	tool_animation = true
	animated_sprite.play("tilling_" + last_direction)
