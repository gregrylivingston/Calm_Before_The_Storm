extends Node

var weather_state_int := -1
var weather_state: WeatherState
var weather_animation_time := 5

var weather_states: Array[WeatherState] = [
	load("res://resource/weather_state/r_weather_state_01.tres"),
	load("res://resource/weather_state/r_weather_state_02.tres"),
	load("res://resource/weather_state/r_weather_state_03.tres"),
	load("res://resource/weather_state/r_weather_state_04.tres"),
	load("res://resource/weather_state/r_weather_state_05.tres"),
	load("res://resource/weather_state/r_weather_state_06.tres"),
	load("res://resource/weather_state/r_weather_state_07.tres"),
	load("res://resource/weather_state/r_weather_state_08.tres"),
	load("res://resource/weather_state/r_weather_state_09.tres"),
	load("res://resource/weather_state/r_weather_state_10.tres")
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	increase_weather_state()
	
signal new_weather_state
	
func increase_weather_state() -> void:
	weather_state_int += 1
	print(weather_state_int)

	if weather_states.size() > weather_state_int:
		weather_state = weather_states[weather_state_int]
		new_weather_state.emit(weather_state)
		print(weather_state.title)
		
		await get_tree().create_timer(8).timeout
		increase_weather_state()
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
