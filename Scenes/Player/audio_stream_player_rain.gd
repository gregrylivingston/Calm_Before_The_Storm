extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(newWeatherState)

func newWeatherState(state: WeatherState) -> void:
	if stream != state.rain_sound:
		stream = state.rain_sound
		play()
