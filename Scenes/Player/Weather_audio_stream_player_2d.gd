extends AudioStreamPlayer2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(newWeatherState)

func newWeatherState(state: WeatherState) -> void:
	stream = load("res://sound/music_queue/alarm.mp3")
	play()
	await get_tree().create_timer(2).timeout
	stream = state.state_sound_track
	play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
