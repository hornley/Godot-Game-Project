class_name DayNightCycleComponent
extends CanvasModulate

@export var initial_day: int = 1:
	set(id):
		initial_day = id
		DayAndNightCycleManager.initial_time.day = id
		DayAndNightCycleManager.set_initial_time()

@export var initial_hour: int = 12:
	set(ih):
		initial_hour = ih
		DayAndNightCycleManager.initial_time.hour = ih
		DayAndNightCycleManager.set_initial_time()

@export var initial_minute: int = 0:
	set(im):
		initial_minute = im
		DayAndNightCycleManager.initial_time.minute = im
		DayAndNightCycleManager.set_initial_time()

@export var day_night_gradient_texture: GradientTexture1D

func _ready() -> void:
	DayAndNightCycleManager.initial_time.day = initial_day
	DayAndNightCycleManager.initial_time.hour = initial_hour
	DayAndNightCycleManager.initial_time.minute = initial_minute
	DayAndNightCycleManager.set_initial_time()
	
	DayAndNightCycleManager.game_time.connect(on_game_time)

func on_game_time(time: float) -> void:
	var sample_value = 0.5 * (sin(time - PI * 0.5) + 1.0)
	#for point in day_night_gradient_texture.gradient.get_point_count() - 1:
		#day_night_gradient_texture.gradient.set_color(point, Color("#230000"))
	color = day_night_gradient_texture.gradient.sample(sample_value)
