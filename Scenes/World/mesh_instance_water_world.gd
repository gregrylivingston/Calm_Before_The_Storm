extends "res://Scenes/World/mesh_instance_water.gd"

func _ready() -> void:
	if OS.get_name() == "Web" || Player.data.isLowGraphicsMode:
		queue_free()

func height_change(newHeight: float) -> void:
	position.y = newHeight - 0.5
