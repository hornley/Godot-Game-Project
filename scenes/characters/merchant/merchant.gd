extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")

var wheat_scene = preload("res://scenes/objects/collectibles/resources/wheat.tscn")
var tomato_scene = preload("res://scenes/objects/collectibles/resources/tomato.tscn")

@export var dialogue_start_command: String
@export var food_drop_height: int = 40
@export var reward_output_radius: int = 20
@export var output_reward_scenes: Array[PackedScene] = []

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var reward_marker: Marker2D = $RewardMarker
@onready var feed_component: FeedComponent = $FeedComponent

var in_range: bool
var is_chest_open: bool


func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.trade_crops.connect(on_trade_crops)
	feed_component.crop_received.connect(on_crop_received)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	if is_chest_open:
		animated_sprite.play("chest_close")
	
	is_chest_open = false
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			interactable_label_component.hide()
			animated_sprite.play("chest_open")
			is_chest_open = true
			
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/village.dialogue"), dialogue_start_command)

func on_trade_crops() -> void:
	if in_range:
		trigger_trade_crops("Wheat", wheat_scene)
		trigger_trade_crops("Tomato", tomato_scene)

func trigger_trade_crops(inventory_item: String, scene: Resource) -> void:
	var inventory: Dictionary = PlayerManager.inventory
	
	if !inventory.has(inventory_item):
		return
	
	var inventory_item_count = inventory[inventory_item]
	
	for index in inventory_item_count:
		var crop_instance = scene.instantiate() as Node2D
		crop_instance.global_position = Vector2(global_position.x, global_position.y - food_drop_height)
		get_tree().root.add_child(crop_instance)
		var target_position = global_position
		
		var time_delay = randf_range(0.5, 2.0)
		await get_tree().create_timer(time_delay).timeout
		
		var tween = get_tree().create_tween()
		tween.tween_property(crop_instance, "position", target_position, 1.0)
		tween.tween_property(crop_instance, "scale", Vector2(0.5, 0.5), 1.0)
		tween.tween_callback(crop_instance.queue_free)
		
		PlayerManager.remove_item(inventory_item)

func on_crop_received(area: Area2D) -> void:
	call_deferred("add_reward_scene")

func add_reward_scene() -> void:
	for scene in output_reward_scenes:
		var reward_scene: Node2D = scene.instantiate()
		var reward_position: Vector2 = get_random_position_in_circle(reward_marker.global_position, reward_output_radius)
		reward_scene.global_position = reward_position
		get_tree().root.add_child(reward_scene)

func get_random_position_in_circle(center: Vector2, radius: int) -> Vector2i:
	var angle = randf() * TAU
	
	var distance_from_center = sqrt(randf()) * radius
	
	var x: int = center.x + distance_from_center * cos(angle)
	var y: int = center.y + distance_from_center * cos(angle)
	
	return Vector2i(x, y)
