extends HBoxContainer

var title: String
var cost: int
var flavor

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label_Name.text = title.replace("_"," ")
	tooltip_text = flavor.tooltip
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
		get_tree().get_first_node_in_group("UpgradeSound").play()
		Player.data.add_upgrade(title)
		Player.data.stars -= cost
		Player.player_stat_upgraded.emit()
