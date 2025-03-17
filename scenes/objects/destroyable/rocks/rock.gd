extends StaticBody2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent
@onready var sprite_2d: Sprite2D = $Sprite2D

var stone_scene = preload("res://scenes/objects/collectibles/resources/stone.tscn")
var parent_node: TileMapLayer

func _ready() -> void:
	parent_node = get_parent()
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damaged_reached)


func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	#material.set_shader_parameter("shake_intensity", 0.5)
	#await get_tree().create_timer(1.0).timeout
	#material.set_shader_parameter("shake_intensity", 0.0)


func on_max_damaged_reached() -> void:
	call_deferred("add_stone_scene")
	queue_free()
	parent_node.erase_cell(parent_node.local_to_map(parent_node.to_local(global_position)))


func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	parent_node.add_child(stone_instance)
