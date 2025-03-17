extends Panel

@onready var sprite: Sprite2D = $Sprite2D
@onready var label: Label = $Label

func update(item_recipe_name: String, amount: int) -> void:
	sprite.texture = GameDataManager.get_item(item_recipe_name).texture
	label.text = item_recipe_name + " x" + str(amount)
