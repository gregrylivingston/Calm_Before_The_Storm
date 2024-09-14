extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.



func _on_button_continue_pressed() -> void:
	get_tree().change_scene_to_file("res://Menus/scenes/menus/main_menu/main_menu_with_animations.tscn")

func endGame():
	Sound.connect_buttons()
	visible = true
	%Label_stars_Earned.text = str(Inventory.stars)
	
