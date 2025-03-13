class_name Chest
extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var storage_component:  = $StorageComponent
@onready var save_data_component: SaveDataComponent = $SaveDataComponent
var is_open: bool = false
var in_range: bool = false

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	save_data_component.save_data_resource = StorageDataResource.new()
	
func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true
	process_mode = PROCESS_MODE_ALWAYS

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false
	process_mode = PROCESS_MODE_INHERIT
	if is_open:
		animated_sprite.play("close")
	is_open = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("interact"):
		if !is_open:
			animated_sprite.play("open")
			is_open = true
		else:
			animated_sprite.play("close")
			is_open = false
		await animated_sprite.animation_finished
		GameManager.game_screen.toggle_storage(storage_component)
