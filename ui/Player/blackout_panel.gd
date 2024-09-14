extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	await get_tree().create_timer(0.5).timeout
	get_tree().create_tween().tween_property(self, "modulate", Color(0,0,0,0),2)
