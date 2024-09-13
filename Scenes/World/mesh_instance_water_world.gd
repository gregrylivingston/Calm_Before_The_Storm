extends "res://Scenes/World/mesh_instance_water.gd"

func _ready() -> void:
	if OS.get_name() == "Web":
		queue_free()

func height_change(newHeight: float) -> void:
	position.y = newHeight - 0.5


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
