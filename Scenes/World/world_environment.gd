extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(new_weather_state)


var last_cloud_level := 1.0
func new_weather_state(weather_state: WeatherState) -> void:
	get_tree().create_tween().tween_method(_set_cloud_level, last_cloud_level, weather_state.cloud_level , Weather.weather_animation_time)
	last_cloud_level = weather_state.cloud_level
	
func _set_cloud_level(cloudLevel: float) -> void:
	environment.sky.sky_material.set_shader_parameter("clouds_cutoff", cloudLevel)
