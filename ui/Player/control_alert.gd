extends Control

func _process(delta: float) -> void:
	_fade_out_alert(delta)
		
func _fade_out_alert(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta
	else:
		process_mode = PROCESS_MODE_DISABLED

func send_alert(text: String) -> void:
	modulate.a = 4
	%Label.text = text
	process_mode = PROCESS_MODE_INHERIT
