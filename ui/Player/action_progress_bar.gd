extends ProgressBar

var displayTimer := 0.5

func _process(delta: float) -> void:
	_fade_out(delta)

func _fade_out(delta:float) -> void:
	displayTimer = displayTimer - delta
	if displayTimer < 0:
		visible = false
		process_mode = PROCESS_MODE_DISABLED

func _on_value_changed(value: float) -> void:
	visible = true
	displayTimer = 0.5
	process_mode = PROCESS_MODE_INHERIT
