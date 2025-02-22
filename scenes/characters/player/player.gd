class_name Player
extends CharacterBody2D

# Player Attributes
var player_name: String
var coins: int

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2
var disable_input_events: bool

func _ready() -> void:
	PlayerManager.set_player(self)
	
	ToolManager.tool_selected.connect(on_tool_selected)

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool
