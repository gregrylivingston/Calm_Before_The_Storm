extends Node

var data: SaveData
signal farm_building_updates

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not FileAccess.file_exists("user://savegame.save"):
		data = SaveData.new()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
