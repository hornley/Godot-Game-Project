class_name Player extends CharacterBody2D

@export var animated_sprite: AnimatedSprite2D
@export var current_tool: Util.Tools = Util.Tools.None
@onready var hit_component: HitComponent = $HitComponent
@onready var storage_component: StorageComponent = $StorageComponent

var player_direction: Vector2
var last_position: Vector2
var disable_input_events: bool

func _ready() -> void:
	if get_parent().name == "GameMenuScreenBackground":
		return
	animated_sprite = $AnimatedSprite2D
	PlayerManager.player = self
	PlayerManager.inventory = storage_component
	PlayerManager.inventory.storage_changed.connect(PlayerManager.on_player_inventory_changed)
	
	HotbarManager.tool_selected.connect(on_tool_selected)
	PlayerManager.player_loaded.emit()

func on_tool_selected(tool: Util.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool

func is_stuck() -> bool:
	return last_position == global_position
