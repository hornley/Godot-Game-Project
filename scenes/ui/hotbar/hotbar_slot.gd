extends Button

@onready var hotbar_item_texture: Sprite2D = $CenterContainer/Panel/HotbarItemTexture
@onready var hotbar_number_label: Label = $CenterContainer/Panel/HotbarNumberLabel
@export var animated_sprite: AnimatedSprite2D

func _ready() -> void:
	animated_sprite = $AnimatedSprite2D

func update_slot_number(number: int) -> void:
	hotbar_number_label.text = str(number)

func update(texture: Texture) -> void:
	hotbar_item_texture.texture = texture

func change_animated_sprite_frame(frame: int) -> void:
	animated_sprite.frame = frame

func _on_mouse_entered() -> void:
	animated_sprite.frame = 1


func _on_mouse_exited() -> void:
	if animated_sprite.frame == 2:
		return
	animated_sprite.frame = 0
