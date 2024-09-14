extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.farm_building_updates.connect(animal_placement_updates)


func animal_placement_updates() -> void:
	update_building_count(%Label2_Kennels, "Kennel")
	update_building_count(%Label2_Barns, "Barn")
	update_building_count( %Label2_Dens, "Den")

#returns animal count
func update_building_count(label: Label, group_name: String) -> int:
	var animalCount: int = 0
	var slotCount: int = 0
	for building in get_tree().get_nodes_in_group(group_name):
		slotCount += building.max_slots
		animalCount += building.used_slots
	label.text = str(animalCount) + " / " + str(slotCount)
	return animalCount


func weather_state_rewards() -> int:
	var rewards := 0
	rewards += update_building_count(%Label2_Kennels, "Kennel")
	rewards += update_building_count(%Label2_Barns, "Barn")
	rewards += update_building_count( %Label2_Dens, "Den")
	return rewards
