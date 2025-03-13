extends StaticBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var log_scene = preload("res://scenes/objects/collectibles/resources/log.tscn")
var parent_node: TileMapLayer

func _ready() -> void:
	parent_node = get_parent()
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	sprite_2d.material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(1.0).timeout
	sprite_2d.material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damaged_reached() -> void:
	call_deferred("add_log_scene")
	queue_free()
	parent_node.erase_cell(parent_node.local_to_map(parent_node.to_local(global_position)))


func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = damage_component.global_position
	parent_node.add_child(log_instance)
