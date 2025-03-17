extends TileMapLayer

@export var world_dict = {}
@onready var farmland_timer: Timer = $"../Farmland_Timer"
@onready var player: CharacterBody2D = $"../../../CharacterBody2D"
@onready var house: Node2D = $"../House"

var hoe_use_is_on_cd = false


func _ready() -> void:
	farmland_timer.connect("timeout", _on_farmland_timer_timeout)

func _process(delta: float) -> void:
	if player.equipped_tool == 2 and Input.is_action_pressed("use_tool"):
		farmland()
		hoe_use_is_on_cd = true


func farmland() -> void:
	if hoe_use_is_on_cd:
		return
		
	farmland_timer.start()
	
	var tile = str(local_to_map(player.position))
	
	if world_dict.has(tile):
		world_dict[str(local_to_map(player.position))]["State"] += 1
	else:
		world_dict[str(local_to_map(player.position))] = {
			"Type": "farmland",
			"State": 0
		}
	
	if world_dict[str(local_to_map(player.position))]["State"] >= 10:
		return
	
	set_cell(local_to_map(player.position), 2, Vector2(world_dict[str(local_to_map(player.position))]["State"]/2, 0))


func _on_farmland_timer_timeout() -> void:
	hoe_use_is_on_cd = false
