class_name WildGrowthComponent extends Node

@export_range(0, 1, 0.01) var wild_growth_chance: float = 1
@export var houses: Node2D
@export var undergrowth: TileMapLayer
@export var land: TileMapLayer

var valid_atlas_coords: Array[Vector2i] = [Vector2i(1, 1), Vector2i(1, 0), Vector2i(5, 2), Vector2i(6, 2)]
var untouched_land_positions: Array[Vector2i] = []

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)
	for cell in land.get_used_cells():
		if land.get_cell_source_id(cell) == 1 and land.get_cell_atlas_coords(cell) in valid_atlas_coords:
			untouched_land_positions.append(cell)
	
	for house in houses.get_children():
		var house_offset: Vector2i = undergrowth.local_to_map(undergrowth.to_local(Vector2i(house.get_global_pos())))
		var used_cells: Dictionary = house.get_used_cells()
		if used_cells.keys().size() == 2:
			for i in range(used_cells["top_left"].x, used_cells["bottom_right"].x + 1):
				for j in range(used_cells["top_left"].y, used_cells["bottom_right"].y + 1):
					var ul_index: int = untouched_land_positions.find(house_offset + Vector2i(i, j))
					if ul_index != -1:
						untouched_land_positions.remove_at(ul_index)

func on_time_tick_day(day: int) -> void:
	for cell in untouched_land_positions:
		if randf() < wild_growth_chance:
			undergrowth.set_cell(cell, 0, Vector2i(1, 3))
