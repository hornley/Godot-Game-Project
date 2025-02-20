class_name Player
extends CharacterBody2D

# Player Attributes
var player_name: String

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

var player_direction: Vector2
var disable_input_events: bool

func _ready() -> void:
	PlayerManager.set_player(self)
	
	ToolManager.tool_selected.connect(on_tool_selected)
	PlayerManager.player_name_changed.connect(on_player_name_changed)
	

func on_tool_selected(tool: DataTypes.Tools) -> void:
	current_tool = tool
	hit_component.current_tool = tool

func on_player_name_changed() -> void:
	player_name = PlayerManager.player_name
