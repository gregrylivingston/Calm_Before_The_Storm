extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Water.height_change.connect(height_change)

func height_change(newHeight: float) -> void:
	position.y = newHeight
