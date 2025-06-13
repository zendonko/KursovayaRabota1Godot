extends SpotLight3D

@export var min_blink_interval: float = 0.05  # минимальное время между вспышками
@export var max_blink_interval: float = 0.5   # максимальное время между вспышками
@export var min_light_energy: float = 0.1     # минимальная яркость
@export var max_light_energy: float = 1.0     # максимальная яркость

var _next_blink_time: float = 0.0
var _timer: float = 0.0

func _ready():
	_schedule_next_blink()

func _process(delta: float) -> void:
	_timer += delta
	if _timer >= _next_blink_time:
		_do_flicker()
		_schedule_next_blink()

func _schedule_next_blink():
	_next_blink_time = randf_range(min_blink_interval, max_blink_interval)
	_timer = 0.0

func _do_flicker():
	# Рандомно выключить или сбросить яркость
	if randi() % 2 == 0:
		light_energy = randf_range(min_light_energy, max_light_energy)
	else:
		light_energy = 0.0
