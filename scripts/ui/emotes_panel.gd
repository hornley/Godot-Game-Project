extends Panel

@onready var animated_sprite: AnimatedSprite2D = $Emote/AnimatedSprite2D
@onready var emote_idle_timer: Timer = $EmoteIdleTimer

var idle_emotes: Array = ["emote_1_idle", "emote_2_smile", "emote_3_ear_wave", "emote_4_blink"]


func _ready() -> void:
	animated_sprite.play("emote_1_idle")
	
	PlayerManager.inventory_changed.connect(on_inventory_changed)
	GameDialogueManager.trade_crops.connect(on_trade_crops)

func play_emote(animation: String) -> void:
	animated_sprite.play(animation)

func _on_emote_idle_timer_timeout() -> void:
	var index = randi_range(0, 3)
	var emote = idle_emotes[index]
	
	animated_sprite.play(emote)

func on_inventory_changed(item: ItemResource) -> void:
	if item == null:
		return
	animated_sprite.play("emote_7_excited")

func on_trade_crops() -> void:
	animated_sprite.play("emote_6_love_Kiss")
