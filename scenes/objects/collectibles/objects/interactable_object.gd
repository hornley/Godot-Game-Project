class_name InteractableObject extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

var in_range: bool
var is_placed: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	toggle_collision()

func on_interactable_activated() -> void:
	if !is_placed:
		return
	
	interactable_label_component.show()
	in_range = true
	process_mode = PROCESS_MODE_ALWAYS

func on_interactable_deactivated() -> void:
	if !is_placed:
		return
	
	interactable_label_component.hide()
	in_range = false
	process_mode = PROCESS_MODE_INHERIT

func _unhandled_input(event: InputEvent) -> void:
	pass

func place() -> void:
	is_placed = true
	add_to_group("placed_objects")
	modulate.a = 1
	toggle_collision()

func toggle_collision() -> void:
	collision_shape_2d.disabled = !collision_shape_2d.disabled
