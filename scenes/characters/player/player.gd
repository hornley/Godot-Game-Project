class_name Player extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent
@export var animated_sprite: AnimatedSprite2D
@export var current_tool: Util.Tools = Util.Tools.None

var player_direction: Vector2
var disable_input_events: bool

func _ready() -> void:
	animated_sprite = $AnimatedSprite2D
	PlayerManager.player = self
	
	HotbarManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: Util.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
