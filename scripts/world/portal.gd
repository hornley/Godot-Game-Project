extends AnimatedSprite2D

@export var world_destination: Util.Worlds

var player_is_in_portal: bool

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and player_is_in_portal:
		GameManager.load_world(world_destination)

func _on_static_body_2d_body_entered(body: Node2D) -> void:
	player_is_in_portal = true


func _on_static_body_2d_body_exited(body: Node2D) -> void:
	player_is_in_portal = false
