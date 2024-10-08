extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Weather.new_weather_state.connect(new_weather_state_rewards)

func new_weather_state_rewards(weatherState: WeatherState) -> void:
	var rewardAmount = $Panel_SafeAnimals.weather_state_rewards()
	Inventory.stars += rewardAmount
	if rewardAmount > 0:Alert.send_alert(str(rewardAmount) + " Stars Earned")
	Alert.send_star_bonus(rewardAmount)
	$Panel_Stars/Label.text = str(Inventory.stars) + " "
