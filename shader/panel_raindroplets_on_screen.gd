extends Panel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(update_weather_state)
	Weather.new_round.connect(reset)
	
func reset():
	previous_value = 4
	update_raindrop_amount(4)

var previous_value := 4.0
func update_weather_state(new_weather_state: WeatherState) -> void:
	var target_value = 4.0 - new_weather_state.water_height/6.0
	get_tree().create_tween().tween_method(update_raindrop_amount,previous_value,target_value,Weather.weather_animation_time)
	previous_value = target_value
	
func update_raindrop_amount(target: float) -> void:
	material.set_shader_parameter("frequency" , target)
