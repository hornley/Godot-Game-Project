class_name CollectibleComponent
extends Area2D

@export var collectible_name: String


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if collectible_name == "Coin":
			var player = body as Player
			PlayerManager.add_coin(6)
		else:
			InventoryManager.add_collectable(collectible_name)
			print("Collected", collectible_name)
		get_parent().queue_free()
