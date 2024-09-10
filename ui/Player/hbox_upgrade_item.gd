extends HBoxContainer

var title: String
var cost: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label_Name.text = title.replace("_"," ")
	call_deferred("_update_values")
	Player.player_stat_upgraded.connect(_update_values)


func _update_values():
	$Label2_Value.text = str(Player.data.upgrade[title] - 1)
	cost = Player.data.upgrade[title] * Player.data.upgrade[title]
	$Button_Upgrade.text = str(cost)
	
	if Player.data.stars < cost:
		$Button_Upgrade.disabled = true


func upgrade() -> void:
	if Player.data.stars >= cost:
		Player.data.add_upgrade(title)
		Player.data.stars -= cost
		Player.player_stat_upgraded.emit()
