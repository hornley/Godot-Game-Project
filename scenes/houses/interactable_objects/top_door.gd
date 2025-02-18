extends StaticBody2D

@onready var door_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var block_player_collision: CollisionShape2D = $BlockPlayerCollision
@export var is_door_open: bool = false

func _process(delta: float) -> void:
	if door_animated_sprite.frame == 1:
		block_player_collision.disabled = is_door_open


func _on_body_entered(body: Node2D) -> void:
	door_animated_sprite.play("open")
	is_door_open = true


func _on_body_exited(body: Node2D) -> void:
	door_animated_sprite.play("close")
	is_door_open = false
