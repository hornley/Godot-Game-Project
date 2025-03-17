extends Resource
class_name ItemRecipeResource

# Input Dictionary of a {"item_name": quantity}
@export var name: String
@export var input: Dictionary
@export var output: ItemResource
@export var crafting_station: Util.CraftingStations
@export var output_texture: Texture
