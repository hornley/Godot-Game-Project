extends Panel

@onready var item_name_label: Label = $VBoxContainer/ItemNameLabel
@onready var silver_coin_label: Label = $VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer/SilverCoinLabel
@onready var gold_coin_label: Label = $VBoxContainer/HBoxContainer/HBoxContainer/VBoxContainer2/GoldCoinLabel

var is_resized = false
var item: ItemResource
var option: String

func update(item_resource: ItemResource) -> void:
	if !item_resource:
		return
	
	item = item_resource
	item_name_label.text = item_resource.name
	var value = item_resource.value
	gold_coin_label.text = str(value / 10)
	silver_coin_label.text = str(value % 10)
	is_resized = false

func _on_button_pressed() -> void:
	if option == "Sell" and PlayerManager.has_item(item.name):
		PlayerManager.remove_item(item.name, 1)
		PlayerManager.add_coin(item.value)
	if option == "Buy":
		PlayerManager.add_item(item.name, 1)
		PlayerManager.add_coin(-item.value)

func _process(delta: float) -> void:
	if !is_resized:
		size.y += item_name_label.get_minimum_size().y - 12
		is_resized = true
