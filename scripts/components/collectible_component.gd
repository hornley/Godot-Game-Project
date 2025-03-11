class_name CollectibleComponent
extends Area2D

@export var item_name: String
@export var item_resource: ItemResource
@export var amount: int = 1

func _ready() -> void:
	if get_parent().name.find("Seed") != -1:
		get_parent().material = ShaderMaterial.new()
		get_parent().material.shader = preload("res://scenes/objects/collectibles/outline.gdshader")

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if item_name == "Coin":
			var player = body as Player
			PlayerManager.add_coin(amount)
			get_parent().queue_free()
		else:
			if PlayerManager.add_item(item_name, item_resource, amount):
				get_parent().queue_free()
