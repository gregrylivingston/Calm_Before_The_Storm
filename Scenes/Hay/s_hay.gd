extends Area3D

@export var hay_to_award := 1
@export var fruit_to_award := 1

@export var destroy_on_award := true


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
