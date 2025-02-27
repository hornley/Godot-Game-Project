extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true
	process_mode = PROCESS_MODE_ALWAYS

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false
	process_mode = PROCESS_MODE_INHERIT

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("interact"):
		GameManager.game_screen.toggle_crafting()
