extends Node

@export var scary_sound_path: String = "res://Sounds/scary_sound.wav"
@export var main_menu_scene: String = "res://Scenes/main menu.tscn" 

var collected_cans: int = 0  
const TOTAL_CANS: int = 3  
var interactable_cans: Array = [] 

@onready var player: CharacterBody3D = $Player 
@onready var scary_sound: AudioStreamPlayer = $ScarySound 
@onready var black_screen: ColorRect = $BlackScreen 

func _ready() -> void:

	if not scary_sound:
		scary_sound = AudioStreamPlayer.new()
		var sound = load(scary_sound_path)
		if sound:
			scary_sound.stream = sound
			add_child(scary_sound)
		else:
			push_error("Failed to load sound file at: ", scary_sound_path)
	

	if not black_screen:
		black_screen = ColorRect.new()
		black_screen.color = Color.BLACK
		black_screen.size = get_viewport().get_visible_rect().size
		black_screen.anchor_right = 1.0
		black_screen.anchor_bottom = 1.0
		black_screen.visible = false
		add_child(black_screen)
	

	for can in get_tree().get_nodes_in_group("cans"):
		var area = can.get_node_or_null("Area3D")
		if area:
			area.connect("body_entered", Callable(self, "_on_can_entered").bind(can))
			area.connect("body_exited", Callable(self, "_on_can_exited").bind(can))
		else:
			push_warning("No Area3D child found in can: ", can.name)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and not event.is_echo():
		if not interactable_cans.is_empty():
			var can = interactable_cans[0] 
			collected_cans += 1
			print("Collected cans: ", collected_cans)
			can.queue_free()
			interactable_cans.clear()  
			
			if collected_cans >= TOTAL_CANS:
				trigger_scary_event()

func _on_can_entered(body: Node3D, can: Node3D) -> void:
	if body.is_in_group("player"):
		interactable_cans.append(can)
		print("Player entered can area: ", can.name)

func _on_can_exited(body: Node3D, can: Node3D) -> void:
	if body.is_in_group("player"):
		if interactable_cans.has(can):
			interactable_cans.erase(can)
			print("Player exited can area: ", can.name)

func trigger_scary_event() -> void:
	if scary_sound and black_screen:
		black_screen.visible = true
		print("Playing scary sound...")
		scary_sound.play()
		if not scary_sound.is_playing():
			push_warning("Scary sound failed to play")
		await scary_sound.finished
		get_tree().change_scene_to_file(main_menu_scene)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  
