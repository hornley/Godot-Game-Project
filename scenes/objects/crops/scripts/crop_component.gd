class_name Crop extends Node2D

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
var crop_name: String
var crop_data: CropData
var growth_state: Util.GrowthStates

func _unhandled_input(event: InputEvent) -> void:
	pass

func _ready() -> void:
	set_crop_data()
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
	
	if growth_state == Util.GrowthStates.Fruiting:
		hurt_component.tool = Util.Tools.Hoe
		crop_overhead_component.change_texture(state_texture["Harvest"])
		crop_overhead_component.visible = true
	else:
		sprite_2d.frame = growth_state + start_frame_offset
	
	if !growth_cycle_component.is_watered and growth_state != Util.GrowthStates.Fruiting:
		crop_overhead_component.change_texture(state_texture["Water"])
		crop_overhead_component.visible = true

func on_hurt(hit_damage: int) -> void:
	if growth_state == Util.GrowthStates.Fruiting:
		on_crop_harvesting()
	
	if !growth_cycle_component.is_watered:
		water()

func fertilize(fertilizer_power: int) -> void:
	growth_cycle_component.fertilizer_power = fertilizer_power
	growth_cycle_component.growth_states(growth_cycle_component.starting_day, DayAndNightCycleManager.current_day)

func water() -> void:
	watering_particles.emitting = true
	await get_tree().create_timer(1).timeout
	crop_overhead_component.change_texture(null)
	crop_overhead_component.visible = false
	watering_particles.emitting = false
	growth_cycle_component.is_watered = true
	crop_data.previous_watered_time = DayAndNightCycleManager.current_time.clone()


func set_crop_data() -> void:
	crop_data = CropData.new()
	
	var cur_time: CustomTime = DayAndNightCycleManager.current_time.clone()
	crop_data.date_planted = cur_time
	crop_data.previous_growth_state_time = cur_time
	
	var seed_item_resource: SeedItemResource = GameDataManager.get_seed_item(crop_name + " Seed")
	
	crop_data.time_of_full_growth = seed_item_resource.time_of_full_growth
	var total_minutes = seed_item_resource.time_of_full_growth.total_minutes() / 6
	crop_data.time_per_growth_state = CustomTime.new(total_minutes / (24 * 60), (total_minutes / 60) % 24, total_minutes % 60)
	crop_data.time_until_next_growth_state = crop_data.time_per_growth_state.clone()
	
	crop_data.water_interval = seed_item_resource.water_interval
	crop_data.time_before_rot = seed_item_resource.time_before_rot

func on_crop_maturity() -> void:
	flowering_particles.emitting = true

func on_crop_harvesting() -> void:
	await PlayerManager.player.animated_sprite.animation_finished
	var harvest_instance = harvest_scene.instantiate() as Node2D
	harvest_instance.global_position = global_position
	get_parent().add_child(harvest_instance)
	
	queue_free()
