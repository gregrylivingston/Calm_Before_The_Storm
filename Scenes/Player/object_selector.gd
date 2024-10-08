extends Area3D

var selectedObject: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CollisionShape3D.position.z = - float(Player.data.upgrade.Grab_Distance / 2)
			
func chop_tree():
	for overlapping_body in get_overlapping_bodies():
		if overlapping_body.has_method("chop_tree"):
			overlapping_body.chop_tree()
			
func break_rock():
	for overlapping_body in get_overlapping_bodies():
		if overlapping_body.has_method("break_rock"):
			overlapping_body.break_rock()
			
func grab_animal(type: Animal3D.Types) -> CharacterBody3D:
	for overlapping_body in get_overlapping_bodies():
		if overlapping_body.has_method("is_animal"):
			if overlapping_body.resource.type == type:
				if Inventory.get_inventory_by_food_type(type) >= overlapping_body.food_demand:
					return overlapping_body
				else:## not enough food
					Alert.send_alert(overlapping_body.resource.group_title + " wants " + str(overlapping_body.food_demand) + " " + Animal3D.Types.find_key(overlapping_body.resource.type) + ".")
			else:  ## wrong food animal match
				overlapping_body.play_basic_sound()
				Alert.send_alert(overlapping_body.resource.group_title + " eat " + Animal3D.Types.find_key(overlapping_body.resource.type) + ".")

	return null
