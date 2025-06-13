extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	if not video_player:
		push_error("VideoStreamPlayer not found!")
		return
	if not audio_player:
		push_error("AudioStreamPlayer not found!")
		return

	video_player.play()
	audio_player.play()
	
	# Проверяем, правильно ли подключен сигнал
	var error = video_player.connect("finished", Callable(self, "_on_video_finished"))
	if error != OK:
		push_error("Failed to connect 'finished' signal: ", error)

func _on_video_finished():
	if audio_player.playing:
		audio_player.stop()
	
	# Диагностика перед сменой сцены
	var scene_path = "res://Scenes/node.tscn"
	if not ResourceLoader.exists(scene_path):
		push_error("Scene file does not exist: ", scene_path)
		return
	
	# Небольшая пауза перед сменой сцены
	await get_tree().create_timer(0.5).timeout
	var error = get_tree().change_scene_to_file(scene_path)
	if error != OK:
		push_error("Failed to change scene to ", scene_path, ", error: ", error)
