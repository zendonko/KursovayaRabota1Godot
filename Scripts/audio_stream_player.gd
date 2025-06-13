extends AudioStreamPlayer

func _ready() -> void:
	connect("finished", Callable(self, "_on_finished"))

func _on_finished() -> void:
	play()
