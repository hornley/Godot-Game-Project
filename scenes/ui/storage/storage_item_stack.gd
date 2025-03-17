class_name StorageItemStack extends Panel

@onready var item_texture: Sprite2D = $ItemTexture
@onready var item_amount_label: Label = $ItemAmountLabel
var item_resource: ItemResource
var scaled: bool = false

func update(item: ItemResource, amount: int) -> void:
	if item:
		item_resource = item
		var region: Rect2 = item_resource.texture.region
		var scale: Vector2 = Vector2(16/region.size.x, 16/region.size.y)
		item_texture.texture = item_resource.texture
		if !scaled:
			item_texture.scale *= scale
			scaled = true
		item_amount_label.text = str(amount)
