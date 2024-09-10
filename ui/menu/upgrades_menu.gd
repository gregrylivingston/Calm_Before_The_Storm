extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Player.player_stat_upgraded.connect(_update_star_count)
	Player.player_stat_upgraded.emit()

func _update_star_count() -> void:
	$Panel_Stars/Label.text = str(Player.data.stars) + " "


func _on_button_clear_pressed() -> void:
	Player.clear_save_game()
