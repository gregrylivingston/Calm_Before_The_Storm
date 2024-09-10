extends Node

var data: SaveData
signal farm_building_updates
signal player_stat_upgraded

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		data = SaveData.new()

#true if successfully upgraded
func upgrade_stat(stat: String) -> bool:
	return false
