extends Node2D

@onready var water_tile_map: TileMapLayer = $Water
@onready var land_tile_map: TileMapLayer = $Land

@export var width: int = 250
@export var height: int = 250

@export var noise_height_texture: NoiseTexture2D
var noise: Noise

var land_source_id: int = 6
var water_source_id: int = 7
var water_atlas: Vector2i = Vector2i(0, 0)
var land_atlas: Vector2i = Vector2i(1, 1)

func _ready() -> void:
	noise = noise_height_texture.noise
	noise_height_texture.noise.seed = get_random_seed()
	generate_world()

func generate_world() -> void:
	var land_terrain_positions: Array[Vector2i]
	for x in range(-width/2, width/2):
		for y in range(-height/2, height/2):
			var noise_val: float = noise.get_noise_2d(x, y)
			if noise_val > 0.0:
				land_terrain_positions.append(Vector2i(x, y))
			water_tile_map.set_cell(Vector2(x, y), water_source_id, water_atlas)
				
	land_tile_map.set_cells_terrain_connect(land_terrain_positions, 0, 1, true)

func get_random_seed() -> int:
	var random_seed = RandomNumberGenerator.new().randi_range(-32768, 32768)
	return random_seed
	
