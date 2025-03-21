extends StaticBody2D

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var upper: Sprite2D = $Upper

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

func on_interactable_activated() -> void:
	upper.modulate.a = 0.5

func on_interactable_deactivated() -> void:
	upper.modulate.a = 1
