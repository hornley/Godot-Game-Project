class_name itemComponent
extends Area2D

@export var item_name: String
@export var item_resource: ItemResource


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if item_name == "Coin":
			var player = body as Player
			PlayerManager.add_coin(6)
		else:
			InventoryManager.add_item(item_name, item_resource)
			print("Collected", item_name)
		get_parent().queue_free()
