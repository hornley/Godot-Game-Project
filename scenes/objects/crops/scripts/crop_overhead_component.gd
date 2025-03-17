extends Control

var texture_rect: TextureRect

func _ready() -> void:
	global_position = get_parent().global_position + Vector2(0, -8)
	texture_rect = $PanelContainer/CenterContainer/TextureRect

func change_texture(_texture: AtlasTexture) -> void:
	texture_rect.texture = _texture
