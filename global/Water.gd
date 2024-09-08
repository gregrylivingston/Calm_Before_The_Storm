extends Node

var height := -1.0:
	set(newHeight):
		height = newHeight
		height_change.emit(height)
signal height_change

@export var water_rising_speed := 0.001

func _ready() -> void:
	Weather.new_weather_state.connect(transition_water_level)

	
func _set_new_height(newHeight) -> void:
	height = newHeight
	
func transition_water_level(weather_state) -> void:
	get_tree().create_tween().tween_method(_set_new_height,height,weather_state.water_height,Weather.weather_animation_time).set_ease(Tween.EASE_IN_OUT)
	
