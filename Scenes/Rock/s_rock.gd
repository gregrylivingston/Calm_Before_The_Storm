extends StaticBody3D

@export var health := 300
@export var max_health := 300

@export var stone_to_award := 1
@export var meshes: Array[MeshInstance3D]

func _ready() -> void:
	for i in meshes:
		if OS.get_name() == "Web": 
			if Player.data.isLowGraphicsMode:
				i.lod_bias = 0.05
				i.visibility_range_end = 40
			else: 
				i.lod_bias = 0.2
		else: #windows etc.
			if Player.data.isLowGraphicsMode:
				i.visibility_range_end = 40

func break_rock():
	if health < 0:
		Inventory.stone += stone_to_award * Player.data.upgrade.Stone_Gathered
		Inventory.update_inventory.emit()
		queue_free()
	else:
		var progress_bar = get_tree().get_first_node_in_group("ActionProgressBar")
		health -= 1 * Player.data.upgrade.Pick_Strength
		progress_bar.value = health
		progress_bar.max_value = max_health
