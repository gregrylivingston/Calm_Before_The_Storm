extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	%ProgressBar_WeatherAlertTimer.value = Weather.state_timer
	%ProgressBar_WeatherAlertTimer.max_value = Weather.state_timer_max
	var timeRemaining := Weather.state_timer_max - Weather.state_timer
	$ProgressBar_WeatherAlertTimer/Label_WeatherStateTimeLeft.text = str(int(timeRemaining))
