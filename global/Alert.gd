extends Node


func send_alert(text: String) -> void:
	get_tree().get_first_node_in_group("Alert").send_alert(text)

func send_instruction(text: String) -> void:
	get_tree().get_first_node_in_group("Instruction").send_alert(text)
	
func send_time_bonus(stars: int) -> void:
	get_tree().get_first_node_in_group("UI_TimeBonus").send_bonus(stars)
	
func send_star_bonus(stars: int) -> void:
	if stars > 0:
		get_tree().get_first_node_in_group("UI_StarBonus").send_bonus(stars)
