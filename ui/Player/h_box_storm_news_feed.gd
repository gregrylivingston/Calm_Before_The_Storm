extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Weather.new_weather_state.connect(_new_weather_state)
	$HBox_StormNewsFeed/VSeparator.custom_minimum_size.x = get_viewport_rect().size.x


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _new_weather_state(newState:WeatherState) -> void:
	$"../WeatherAlertTimer".visible = false
	%Label_WeatherInfo.text  = newState.title + "."
	if Weather.weather_state_int > 4:
		%Label_WeatherInfo.text += "  Flooding imminent.  Seek higher ground."
	
	position.x = 0 - size.x/2#(get_viewport_rect().size.x / 2) - 100
	visible = true
	await  get_tree().create_timer(.25).timeout
	visible = false
	await  get_tree().create_timer(.25).timeout
	visible = true
	await  get_tree().create_timer(.25).timeout
	visible = false
	await  get_tree().create_timer(.25).timeout
	visible = true
	await  get_tree().create_timer(.25).timeout
	visible = false
	await  get_tree().create_timer(.25).timeout
	visible = true
	await  get_tree().create_timer(1).timeout
	get_tree().create_tween().tween_property(self,"position",Vector2(-3000 , position.y), 5)
	await  get_tree().create_timer(5).timeout
	$"../WeatherAlertTimer".visible = true
