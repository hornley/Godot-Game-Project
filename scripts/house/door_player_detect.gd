extends StaticBody2D

@onready var door_animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var block_player_collision: CollisionShape2D = $BlockPlayerCollision
@onready var light_occluder_2d: LightOccluder2D = $LightOccluder2D
@export var is_door_open: bool = false

func _process(delta: float) -> void:
	if door_animated_sprite.frame == 2:
		block_player_collision.disabled = is_door_open

func _on_body_entered(body: Node2D) -> void:
	door_animated_sprite.play("open")
	is_door_open = true
	light_occluder_2d.visible = false

func _on_body_exited(body: Node2D) -> void:
	door_animated_sprite.play("close")
	is_door_open = false
	light_occluder_2d.visible = true
