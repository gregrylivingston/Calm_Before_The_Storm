extends HBoxContainer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_fade_out(delta)
		
func _fade_out(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta
	else:
		process_mode = PROCESS_MODE_DISABLED	

func send_bonus(amount: int) -> void:
	$AudioStreamPlayer2D.play()
	modulate.a = 4
	$Label.text = "+ " + str(amount)
	process_mode = PROCESS_MODE_INHERIT
