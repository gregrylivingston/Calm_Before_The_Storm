extends Node

var data: SaveData
signal farm_building_updates
signal player_stat_upgraded

var saveFileLocation := "user://savegame.tres"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not ResourceLoader.exists(saveFileLocation):
		data = SaveData.new()
	else:data = ResourceLoader.load(saveFileLocation)
	player_stat_upgraded.connect(save_game)

	
func save_game() -> void:
	ResourceSaver.save(data,saveFileLocation)
	
func clear_save_game() -> void:
	data = SaveData.new()
	save_game()
	player_stat_upgraded.emit()
