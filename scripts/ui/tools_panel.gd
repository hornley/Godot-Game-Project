extends PanelContainer

@onready var tool_axe: Button = $MarginContainer/HBoxContainer/ToolAxe
@onready var tool_hoe: Button = $MarginContainer/HBoxContainer/ToolHoe
@onready var tool_watering_can: Button = $MarginContainer/HBoxContainer/ToolWateringCan
@onready var tool_wheat: Button = $MarginContainer/HBoxContainer/ToolWheat
@onready var tool_tomato: Button = $MarginContainer/HBoxContainer/ToolTomato


func _ready() -> void:
	ToolManager.enable_tool.connect(on_enable_tool_button)
	
	#tool_axe.disabled = true
	#tool_axe.focus_mode = Control.FOCUS_NONE
	#
	#tool_hoe.disabled = true
	#tool_hoe.focus_mode = Control.FOCUS_NONE
	#
	#tool_watering_can.disabled = true
	#tool_watering_can.focus_mode = Control.FOCUS_NONE
	#
	#tool_wheat.disabled = true
	#tool_wheat.focus_mode = Control.FOCUS_NONE
	#
	#tool_tomato.disabled = true
	#tool_tomato.focus_mode = Control.FOCUS_NONE


func _on_tool_axe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.Axe)


func _on_tool_hoe_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.Hoe)


func _on_tool_watering_can_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.WateringCan)


func _on_tool_wheat_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantWheat)


func _on_tool_tomato_pressed() -> void:
	ToolManager.select_tool(DataTypes.Tools.PlantTomato)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("release_tool"):
		ToolManager.select_tool(DataTypes.Tools.None)
		tool_axe.release_focus()
		tool_hoe.release_focus()
		tool_watering_can.release_focus()
		tool_wheat.release_focus()
		tool_tomato.release_focus()


func on_enable_tool_button(tool: DataTypes.Tools) -> void:
	if tool == DataTypes.Tools.Hoe:
		tool_hoe.disabled = false
		tool_hoe.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.Axe:
		tool_axe.disabled = false
		tool_axe.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.WateringCan:
		tool_watering_can.disabled = false
		tool_watering_can.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.PlantWheat:
		tool_wheat.disabled = false
		tool_wheat.focus_mode = Control.FOCUS_ALL
	elif tool == DataTypes.Tools.PlantTomato:
		tool_tomato.disabled = false
		tool_tomato.focus_mode = Control.FOCUS_ALL
