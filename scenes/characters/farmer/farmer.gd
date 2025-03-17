class_name Farmer extends Node2D

var balloon_scene = preload("res://dialogue/game_dialogue_balloon.tscn")
const FARMER_SHOP_GUI = preload("res://scenes/ui/farmer/farmer_shop_gui.tscn")

@export var dialogue_start_command: String

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var interactable_label_component: Control = $InteractableLabelComponent
@onready var storage_component: StorageComponent = $StorageComponent

var in_range: bool

func _ready() -> void:
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)
	GameDialogueManager.farmer_shop_gui.connect(on_farmer_shop_gui)
	interactable_label_component.hide()
	load_items()

func load_items() -> void:
	for item_name: String in GameDataManager.seeds.keys():
		var item_resource: ItemResource = GameDataManager.items[item_name.left(item_name.length() - 5)]
		var item_seed_resource: SeedItemResource = GameDataManager.seeds[item_name]
		item_seed_resource.value = item_resource.value * 0.8
		storage_component.add_item(item_name, item_seed_resource, 1)

func on_interactable_activated() -> void:
	interactable_label_component.show()
	in_range = true

func on_interactable_deactivated() -> void:
	interactable_label_component.hide()
	in_range = false

func _unhandled_input(event: InputEvent) -> void:
	if in_range:
		if event.is_action_pressed("interact"):
			var balloon: BaseGameDialogueBalloon = balloon_scene.instantiate()
			get_tree().root.add_child(balloon)
			balloon.start(load("res://dialogue/conversations/village.dialogue"), dialogue_start_command)

func on_farmer_shop_gui(option: String) -> void:
	var farmer_shop_gui_scene = FARMER_SHOP_GUI.instantiate()
	farmer_shop_gui_scene.farmer = self
	farmer_shop_gui_scene.option = option
	GameManager.game_screen.add_child(farmer_shop_gui_scene)
