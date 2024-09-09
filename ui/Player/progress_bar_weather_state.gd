extends ProgressBar




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(_update_weather_state)

func _update_weather_state(newState: WeatherState) -> void:
	get_tree().create_tween().tween_property(self,"value",Weather.weather_state_int,Weather.weather_animation_time)
	
