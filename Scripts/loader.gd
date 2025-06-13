extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func make_stub(pos: Vector3, path: String):
	var stub := Node3D.new()
	stub.name = "Stub"
	stub.global_position = pos
	stub.set_meta("scene_path", path)
	stub.add_to_group("streamed_object")
	add_child(stub)
