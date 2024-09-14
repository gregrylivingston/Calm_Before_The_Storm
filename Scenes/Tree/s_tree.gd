extends StaticBody3D

@export var health := 300
@export var max_health := 300

@export var wood_to_award := 1
@export var fruit_to_award := 1

func _ready() -> void:
	var mesh = get_child(0).get_child(0)
	if OS.get_name() == "Web": 
		if Player.data.isLowGraphicsMode:
			mesh.lod_bias = 0.05
			mesh.visibility_range_end = 40
		else: 
			mesh.lod_bias = 0.2
	else: #windows etc.
		if Player.data.isLowGraphicsMode:
			mesh.visibility_range_end = 40

func chop_tree():
	if health < 0:
		Inventory.wood += wood_to_award * Player.data.upgrade.Wood_Gathered
		Inventory.fruit += fruit_to_award * Player.data.upgrade.Fruit_Gathered
		Inventory.update_inventory.emit()
		queue_free()
	else:
		var progress_bar = get_tree().get_first_node_in_group("ActionProgressBar")
		health -= 1 * Player.data.upgrade.Chop_Strength
		progress_bar.value = health
		progress_bar.max_value = max_health
	
