extends Node3D

@export var interaction_distance: float = 2.0
@export var note_texture: Texture2D 
@export var note_ui: TextureRect

var player: CharacterBody3D
var can_interact: bool = false
var note_visible: bool = false

func _ready():

	player = get_tree().get_first_node_in_group("player")
	if !player:
		push_error("Player not found in group 'player'")
	

	if note_ui:
		note_ui.visible = false

func _process(delta):
	if !player:
		return

	var distance = global_position.distance_to(player.global_position)
	can_interact = distance <= interaction_distance
	

	if can_interact and Input.is_action_just_pressed("interact"):
		toggle_note()

func toggle_note():
	note_visible = !note_visible
	
	if note_ui:
		note_ui.visible = note_visible
		note_ui.texture = note_texture
	

	if note_visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
