class_name InventoryGUI extends StorageGUI

func _ready() -> void:
	PlayerManager.player_loaded.connect(on_player_loaded)
	PlayerManager.inventory_changed.connect(on_inventory_changed)

func on_player_loaded() -> void:
	storage_component = PlayerManager.inventory
	super.load_slots()

func on_inventory_changed(item: ItemResource) -> void:
	update()
