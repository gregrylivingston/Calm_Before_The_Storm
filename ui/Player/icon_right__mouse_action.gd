extends VSeparator


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Ui.right_mouse_icon = self


func set_right_mouse_action_text(text: String = "") -> void:
	if text.length() > 1:
		%Label2.text = text
		get_child(0).visible = true
	else:
		get_child(0).visible = false
