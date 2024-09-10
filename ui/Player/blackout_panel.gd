extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = true
	await get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property(self, "modulate", Color(0,0,0,0),2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
