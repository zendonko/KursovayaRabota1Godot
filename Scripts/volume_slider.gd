extends HSlider

func _ready() -> void:
	value_changed.connect(_on_value_changed)
	# Загрузка сохраненной громкости
	var config = ConfigFile.new()
	if config.load("user://settings.cfg") == OK:
		value = config.get_value("audio", "volume", 0.5)

func _on_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value))
	# Сохранение настройки
	var config = ConfigFile.new()
	config.set_value("audio", "volume", value)
	config.save("user://settings.cfg")
