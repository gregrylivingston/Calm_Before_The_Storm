extends Control

enum UpgradeTypes {Tools, Gathering, Character, Gamerules}
var upgradeFlavor: Dictionary = {
	"Weather_Alert_Delay":{"tooltip":"Extends the base time between weather alerts and flood events.","icon":"","group":UpgradeTypes.Gamerules},  	#added
	"Dig_Strength":{"tooltip":"Dig faster.","icon":"","group":UpgradeTypes.Tools},		  	#added
	"Dirt_Gathered":{"tooltip":"Increases dirt gathered from digging.","icon":"","group":UpgradeTypes.Gathering},		  	#added
	"Chop_Strength":{"tooltip":"Chop faster with your axe.","icon":"","group":UpgradeTypes.Tools},	      	#added
	"Wood_Gathered":{"tooltip":"Increases dirt gathered from chopping trees.","icon":"","group":UpgradeTypes.Gathering},		  	#added
	"Pick_Strength":{"tooltip":"Pick stone faster with your pickaxe.","icon":"","group":UpgradeTypes.Tools},			#added
	"Stone_Gathered":{"tooltip":"Increases stone gathered from picking rocks.","icon":"","group":UpgradeTypes.Gathering},			#added
	"Fruit_Gathered":{"tooltip":"Increases fruit gathered from plants.","icon":"","group":UpgradeTypes.Gathering},			#added
	"Hay_Gathered":{"tooltip":"Increases hay gathered from grasses.","icon":"","group":UpgradeTypes.Gathering},			#added
	"Meat_Gathered":{"tooltip":"Increases meat gathered from prey.","icon":"","group":UpgradeTypes.Gathering},			#added
	"Full_Building_Bonus":{"tooltip":"Increases the weather alert delay bonus for filling a building.","icon":"","group":UpgradeTypes.Gamerules},
	"Sprint_Speed":{"tooltip":"Increases sprinting speed.","icon":"","group":UpgradeTypes.Character},
	"Jump_Height":{"tooltip":"Increases jump height.","icon":"","group":UpgradeTypes.Character},
	"Grab_Distance":{"tooltip":"Increases animal grab distance.","icon":"","group":UpgradeTypes.Character},
	"Hold_Distance":{"tooltip":"Increases the max placement distance for animals and buildings.","icon":"","group":UpgradeTypes.Character},
}

@onready var listByType : Dictionary = {
	UpgradeTypes.Gamerules: %Gameplay,
	UpgradeTypes.Tools:%Tools,
	UpgradeTypes.Gathering:%Gathering,
	UpgradeTypes.Character:%Character,
}

var item_upgrade_hbox = load("res://ui/Player/hbox_upgrade_item.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.player_stat_upgraded.connect(_update_star_count)
	Player.player_stat_upgraded.emit()
	rebuild_upgrade_list()
		
func rebuild_upgrade_list() -> void:
	for i in listByType: for vbox in listByType[i].get_children():vbox.queue_free()
	for upgrade in Player.data.upgrade:
		var newBox = item_upgrade_hbox.instantiate()
		newBox.title = upgrade
		if not upgradeFlavor.has(upgrade):
			Player.clear_save_game()
			break
		newBox.flavor = upgradeFlavor[upgrade]
		
		listByType[upgradeFlavor[upgrade].group].add_child(newBox)
		
func _update_star_count() -> void:
	$Panel_Stars/Label.text = str(Player.data.stars) + " "

func _on_button_clear_pressed() -> void:
	Player.clear_save_game()
	rebuild_upgrade_list()
