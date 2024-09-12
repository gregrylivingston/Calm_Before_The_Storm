class_name SaveData extends Resource

@export var upgrade = {
	"Weather_Alert_Delay":1,  	#added
	"Dig_Strength":1,		  	#added
	"Dirt_Gathered":1,		  	#added
	"Chop_Strength":1,	      	#added
	"Wood_Gathered":1,		  	#added
	"Pick_Strength":1,			#added
	"Stone_Gathered":1,			#added
	"Fruit_Gathered":1,			#added
	"Hay_Gathered":1,			#added
	"Meat_Gathered":1,			#added
	"Full_Building_Bonus":1,
	"Sprint_Speed":1,
	"Jump_Height":1,
	"Grab_Distance":1,
	"Hold_Distance":1,
}

@export var stars := 25


func add_upgrade(title: String) -> void:
	upgrade[title] += 1
