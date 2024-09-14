extends Control

@export var label: Label

func _process(delta: float) -> void:
	_fade_out_alert(delta)
		
func _fade_out_alert(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta
	else:
		process_mode = PROCESS_MODE_DISABLED

func send_alert(text: String) -> void:
	process_mode = PROCESS_MODE_INHERIT

	modulate.a = 4
	label.text = text
