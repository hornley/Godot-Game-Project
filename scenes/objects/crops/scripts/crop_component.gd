extends Node2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var watering_particles: GPUParticles2D = $WateringParticles
@onready var flowering_particles: GPUParticles2D = $FloweringParticles
@onready var growth_cycle_component: GrowthCycleComponent = $GrowthCycleComponent
@onready var hurt_component: HurtComponent = $HurtComponent

@export var harvest_scene: PackedScene
var start_frame_offset: int
var crop_overhead_component: Control
const CROP_OVERHEAD_COMPONENT = preload("res://scenes/objects/crops/crop_overhead_component.tscn")
var state_texture: Dictionary = {
	"Water": preload("res://scenes/objects/crops/water_texture.tres"),
	"Harvest": preload("res://scenes/objects/crops/harvest_texture.tres")
}
var growth_state: Util.GrowthStates

func _unhandled_input(event: InputEvent) -> void:
	pass

func _ready() -> void:
	start_frame_offset = sprite_2d.frame
	var crop_overhead_instance = CROP_OVERHEAD_COMPONENT.instantiate()
	add_child(crop_overhead_instance)
	crop_overhead_instance.change_texture(state_texture["Water"])
	crop_overhead_component = crop_overhead_instance
	
	crop_overhead_component.visible = false
	watering_particles.emitting = false
	flowering_particles.emitting = false
	
	hurt_component.hurt.connect(on_hurt)
	growth_cycle_component.crop_maturity.connect(on_crop_maturity)
	growth_cycle_component.crop_harvesting.connect(on_crop_harvesting)

func _process(delta: float) -> void:
	growth_state = growth_cycle_component.get_current_growth_state()
	
	if growth_state == Util.GrowthStates.Flowering:
		flowering_particles.emitting = true
	
	if growth_state == Util.GrowthStates.Harvesting:
		hurt_component.tool = Util.Tools.Hoe
		crop_overhead_component.change_texture(state_texture["Harvest"])
		crop_overhead_component.visible = true
	else:
		sprite_2d.frame = growth_state + start_frame_offset
	
	if !growth_cycle_component.is_watered:
		crop_overhead_component.change_texture(state_texture["Water"])
		crop_overhead_component.visible = true

func on_hurt(hit_damage: int) -> void:
	if growth_state == Util.GrowthStates.Harvesting:
		await PlayerManager.player.animated_sprite.animation_finished
		on_crop_harvesting()
	
	if !growth_cycle_component.is_watered:
		watering_particles.emitting = true
		await get_tree().create_timer(1).timeout
		crop_overhead_component.change_texture(null)
		crop_overhead_component.visible = false
		watering_particles.emitting = false
		growth_cycle_component.is_watered = true
		growth_cycle_component.update()

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	var harvest_instance = harvest_scene.instantiate() as Node2D
	harvest_instance.global_position = global_position
	get_parent().add_child(harvest_instance)
	
	queue_free()

func fertilize(fertilizer_power: int) -> void:
	growth_cycle_component.fertilizer_power = fertilizer_power
	growth_cycle_component.growth_states(growth_cycle_component.starting_day, DayAndNightCycleManager.current_day)
