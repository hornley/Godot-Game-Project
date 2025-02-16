extends Node2D

@onready var camera: Camera2D = $"../CharacterBody2D/Camera2D"
@onready var player: CharacterBody2D = $"../CharacterBody2D"
@onready var grid_timer: Timer = $Grid_Timer
var grid_enabled: bool = false
var grid_toggle_is_on_cd = false


func _ready():
	grid_timer.connect("timeout", _on_grid_timer_timeout)


func _draw():
	if not grid_enabled:
		return
		
	var viewport_rect = camera.get_viewport_rect()
	var width = viewport_rect.size.x
	var height = viewport_rect.size.y
	
	for x in range(-width, width, 16):
		draw_line(Vector2(x, -height), Vector2(x, height), Color.GRAY, 1)
	
	for y in range(-height, height, 16):
		draw_line(Vector2(-width, 8-y), Vector2(width, 8-y), Color.GRAY, 1)


func _process(_delta):
	if Input.is_action_pressed("toggle_grid") or Input.is_action_pressed("toggle_hoe"):
		toggle_grid()
	
	queue_redraw()


func toggle_grid():
	if not grid_toggle_is_on_cd:
		grid_enabled = not grid_enabled
		grid_toggle_is_on_cd = true
		grid_timer.start()
	


func _on_grid_timer_timeout() -> void:
	grid_toggle_is_on_cd = false
