extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
var wheat_seed_resource: ItemResource = preload("res://resources/items/seeds/wheat_seed.tres")
var tomato_seed_resource: ItemResource = preload("res://resources/items/seeds/tomato_seed.tres")
var axe_resource = preload("res://resources/items/tools/axe.tres")
@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	interactable_label_component.hide()
	
	GameDialogueManager.give_crop_seeds.connect(on_give_crop_seeds)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range and event.is_action_pressed("interact"):
		var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
		get_tree().root.add_child(balloon)
		balloon.start(load("res://dialogue/conversations/guide.dialogue"), "start")

func on_give_crop_seeds() -> void:
	PlayerManager.add_item("Axe", axe_resource, 1)
	PlayerManager.add_item("Wheat Seed", wheat_seed_resource, 1)
	PlayerManager.add_item("Tomato Seed", tomato_seed_resource, 1)
