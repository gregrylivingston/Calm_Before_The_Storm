extends WorldEnvironment


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(new_weather_state)


var last_cloud_level := 1.0
func new_weather_state(weather_state: WeatherState) -> void:
	get_tree().create_tween().tween_method(_set_cloud_level, last_cloud_level, weather_state.cloud_level , Weather.weather_animation_time)
	last_cloud_level = weather_state.cloud_level
	
func _set_cloud_level(cloudLevel: float) -> void:
	environment.sky.sky_material.set_shader_parameter("clouds_cutoff", cloudLevel) #goes from 1 -> 0 (or low)
	var horizon_calculator = ( 1.0 - cloudLevel ) / 10.0 
	environment.sky.sky_material.set_shader_parameter("horizon_color", Color(0,.68 - horizon_calculator,.8 - horizon_calculator,1))
	var sun_rotation = -90 + ( 1 - cloudLevel ) * 45
	$"../DirectionalLight3D".rotation_degrees.x = sun_rotation
