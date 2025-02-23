class_name InventoryItemStack extends Panel

@onready var item_texture: Sprite2D = $ItemTexture
@onready var item_amount_label: Label = $ItemAmountLabel
var item_resource: ItemResource

func update(item: ItemResource, amount: int) -> void:
	if item:
		item_resource = item
		item_texture.texture = item.texture
		item_amount_label.text = str(amount)
