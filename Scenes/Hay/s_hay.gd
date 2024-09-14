extends Area3D

@export var hay_to_award := 1
@export var fruit_to_award := 1

@export var destroy_on_award := true

@export var meshes : Array[MeshInstance3D]

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


#this should only be the player....
func _on_body_entered(body: Node3D) -> void:
	if hay_to_award > 0:
		Inventory.hay += hay_to_award * Player.data.upgrade.Hay_Gathered
	if fruit_to_award >0:
		Inventory.fruit += fruit_to_award * Player.data.upgrade.Fruit_Gathered
	if hay_to_award > 0 || fruit_to_award > 0:
		Inventory.update_inventory.emit()
		
	if destroy_on_award:
		queue_free()
