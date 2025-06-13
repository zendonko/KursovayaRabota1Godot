extends PathFollow3D

var speed = 0.05  # Скорость от 0 до 1 (для Progress Ratio)

func _process(delta):
	progress_ratio += speed * delta
	# Зацикливание (опционально)
	if progress_ratio >= 1.0:
		progress_ratio = 0.0
