extends VSeparator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ui.left_mouse_icon = self

func set_left_mouse_action_text(text: String) -> void:
	if text.length() > 1:
		%Label.text = text
		get_child(0).visible = true
	else:
		get_child(0).visible = false
