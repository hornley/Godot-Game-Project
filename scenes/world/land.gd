extends TileMapLayer

@onready var bridges: TileMapLayer = $"../Bridges"
@onready var tilled_soil: TileMapLayer = $"../TilledSoil"
@export var houses: Node2D

const RIGHT_CLICK_ANIMATION = preload("res://test/right_click_animation.tscn")

var right_click_animation_scene: Node2D
var astargrid2d: AStarGrid2D
var last_path: Array[Vector2]

func _ready() -> void:
	var region = get_used_rect()
	var bridges_used_cells = bridges.get_used_cells()
	
	var solid_cells = []
	for i in range(region.position.x, region.size.x + 1):
		for j in range(region.position.y, region.size.y + 1):
			var cell = Vector2i(i, j)
			if cell in bridges_used_cells:
				continue
			var tile_data = get_cell_tile_data(cell)
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				solid_cells.append(cell)
	
	for house in houses.get_children():
		var house_offset: Vector2i = local_to_map(to_local(Vector2i(house.get_global_pos())))
		for cell in house.get_used_cells():
			solid_cells.append(cell + house_offset)

	
	astargrid2d = AStarGrid2D.new()
	astargrid2d.region = region
	astargrid2d.cell_size = Vector2i(16, 16)
	astargrid2d.default_compute_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid2d.default_estimate_heuristic = AStarGrid2D.HEURISTIC_MANHATTAN
	astargrid2d.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER
	astargrid2d.update()
	
	for solid_cell in solid_cells:
		astargrid2d.set_point_solid(solid_cell)
		#set_cell(solid_cell, 1, Vector2i(1, 1), 1)

func _process(delta: float) -> void:
	var path_size = PlayerManager.path.size()
	
	last_path.clear()
	
	if path_size > 0:
		var path = PlayerManager.path
			
		for index in range(PlayerManager.current_path_index, path_size):
			var cell_pos = path[index]
			if cell_pos not in last_path:
				last_path.append(cell_pos)
			#set_cell(local_to_map(cell_pos), 1, Vector2i(1, 1), 1)
	else:
		if right_click_animation_scene:
			remove_child(right_click_animation_scene)
			right_click_animation_scene = null

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		var mouse_pos: Vector2i = local_to_map(to_local(get_global_mouse_position()))
		path_find(mouse_pos)

func path_find(mouse_pos: Vector2i, include_last_path: bool = true) -> bool:
	var player_pos = get_player_pos()
	
	var path: Array[Vector2i] = astargrid2d.get_id_path(player_pos, mouse_pos)
	
	if path.is_empty():
		for cell_around in get_surrounding_cells(mouse_pos):
			path = astargrid2d.get_id_path(player_pos, cell_around)
			if !path.is_empty():
				break
	
	if path.is_empty():
		return false
	
	if !include_last_path:
		path.pop_back()
	
	var positions: Array = path.map(func(cell): return map_to_local(cell))
	PlayerManager.set_path_find(positions)
	
	if right_click_animation_scene:
		remove_child(right_click_animation_scene)
		right_click_animation_scene = null
	
	right_click_animation_scene = RIGHT_CLICK_ANIMATION.instantiate()
	right_click_animation_scene.global_position = map_to_local(mouse_pos)
	add_child(right_click_animation_scene)
	
	if !await PlayerManager.player_path_find_finished:
		return false
	
	return true

func get_player_pos() -> Vector2i:
	var player_pos: Vector2i = local_to_map(to_local(PlayerManager.player.global_position))
	if astargrid2d.is_point_solid(player_pos):
		for cell_around in get_surrounding_cells(player_pos):
			if astargrid2d.is_point_solid(cell_around):
				continue
			elif astargrid2d.is_point_solid((cell_around + player_pos) / 2):
				continue
			
			player_pos = cell_around
			break
	return player_pos
