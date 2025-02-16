extends CanvasLayer

@export var grid_width = 32
@export var grid_height = 32
@export var grid_color = Color.GRAY
@onready var camera: Camera2D = $"../CharacterBody2D/Camera2D"
var canvas_item

func _ready() -> void:
	canvas_item = get_canvas() # Get the CanvasItem to draw on
	canvas_item.draw_line(Vector2(12, 0), Vector2(12, 5), grid_color, 1)

func _draw():
	var viewport_rect = camera.get_viewport_rect()
	var width = viewport_rect.size.x
	var height = viewport_rect.size.y
	

	for x in range(0, width, grid_width):
		canvas_item.draw_line(Vector2(x, 0), Vector2(x, height), grid_color, 1)

	for y in range(0, height, grid_height):
		canvas_item.draw_line(Vector2(0, y), Vector2(width, y), grid_color, 1)

#Example to update the grid
func update_grid(new_width, new_height):
	grid_width = new_width
	grid_height = new_height
	canvas_item.update() #Force redraw
