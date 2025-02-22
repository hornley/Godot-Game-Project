extends Panel

@onready var item_texture: Sprite2D = $CenterContainer/Panel/ItemTexture
@onready var item_amount_label: Label = $CenterContainer/Panel/ItemAmountLabel

func update(item: ItemResource, amount: int) -> void:
	if item:
		item_texture.texture = item.texture
		item_amount_label.text = str(amount)
