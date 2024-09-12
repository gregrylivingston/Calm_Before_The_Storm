extends HBoxContainer



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if modulate.a > 0:
		modulate.a -= delta


func send_time_bonus(amount: int) -> void:
	$AudioStreamPlayer2D.play()
	modulate.a = 4
	$Label.text = str(amount)
