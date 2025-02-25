class_name CraftableItemStack extends Panel

@onready var item_texture: Sprite2D = $ItemTexture
var item_recipe_resource: ItemRecipeResource
var scaled: bool = false

func update(item_recipe: ItemRecipeResource) -> void:
	if item_recipe:
		var region: Rect2 = item_recipe.output_texture.region
		var scale: Vector2 = Vector2(16/region.size.x, 16/region.size.y)
		item_recipe_resource = item_recipe
		item_texture.texture = item_recipe.output_texture
		if !scaled:
			item_texture.scale = scale * item_texture.scale
			scaled = true
