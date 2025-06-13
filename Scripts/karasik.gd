extends CharacterBody3D

@export var spawn_interval: float = 30.0
@export var appear_distance: float = 25.0
@export var peripheral_angle: float = 120.0
@export var disappear_angle: float = 15.0
@export var mesh_instance: MeshInstance3D

var player: Camera3D  # Теперь явно используем камеру
var is_visible: bool = false
var spawn_timer: Timer

func _ready():
	# Ищем именно камеру игрока
	player = get_tree().get_first_node_in_group("player_camera")
	if !player:
		player = get_viewport().get_camera_3d()
	if !player:
		push_error("Player camera not found!")
		return
	
	hide_fish()
	
	spawn_timer = Timer.new()
	spawn_timer.wait_time = spawn_interval
	spawn_timer.autostart = true
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	add_child(spawn_timer)

func _process(delta):
	if !is_visible or !player:
		return
	
	# Новый надежный способ проверки видимости
	if is_visible and is_directly_viewed():
		hide_fish()

func _on_spawn_timer_timeout():
	if !player:
		return
	
	# Генерация позиции в периферийном зрении
	var random_angle = deg_to_rad(randf_range(-peripheral_angle, peripheral_angle))
	var direction = -player.global_transform.basis.z.rotated(Vector3.UP, random_angle)
	
	var spawn_pos = player.global_position + direction * appear_distance
	spawn_pos.y = player.global_position.y
	
	global_position = spawn_pos
	look_at(player.global_position)
	show_fish()

func is_directly_viewed() -> bool:
	# Вектор от камеры к рыбе
	var camera_to_fish = global_position - player.global_position
	var distance = camera_to_fish.length()
	var direction = camera_to_fish.normalized()
	
	# Вектор направления взгляда камеры
	var camera_forward = -player.global_transform.basis.z
	
	# Угол между направлением взгляда и направлением на рыбу
	var angle = rad_to_deg(camera_forward.angle_to(direction))
	
	# Проверка нахождения в центральном обзоре
	if angle > disappear_angle:
		return false
	
	# Дополнительная проверка с помощью raycast
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(
		player.global_position,
		global_position,
		1 << 0  # Проверяем только первый слой коллизий
	)
	var result = space_state.intersect_ray(query)
	
	# Если луч попал в рыбу - значит она видна
	if result.is_empty() or result.collider == self:
		return true
	
	return false

func show_fish():
	is_visible = true
	if mesh_instance:
		mesh_instance.visible = true
	spawn_timer.start(spawn_interval)

func hide_fish():
	is_visible = false
	if mesh_instance:
		mesh_instance.visible = false
