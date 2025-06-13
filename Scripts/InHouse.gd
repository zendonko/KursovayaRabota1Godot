extends Area3D

@export var target_position: Vector3 = Vector3(153.0, 255.0, 879.0)  # Целевые координаты

func _ready() -> void:
	# Подключаем сигналы для обнаружения игрока
	connect("body_entered", Callable(self, "_on_body_entered"))
	connect("body_exited", Callable(self, "_on_body_exited"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		# Проверяем, находится ли игрок в зоне
		for body in get_overlapping_bodies():
			if body is CharacterBody3D and (body.name == "Player" or body.is_in_group("player")):
				# Переносим игрока на целевые координаты
				body.global_position = target_position
				print("Player teleported to ", target_position)
				break

func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and (body.name == "Player" or body.is_in_group("player")):
		print("Player entered interact area")

func _on_body_exited(body: Node3D) -> void:
	if body is CharacterBody3D and (body.name == "Player" or body.is_in_group("player")):
		print("Player exited interact area")
