extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	

@onready var ui_scenes = [$"../VBoxContainer", $"../Control_TopCenter", $"../Control_Center", $"../Control_BottomCenter", $"../VBox_RightPanel",  $"../Control_Alert", $"../Control_Instructions"]

func pause() -> void:
	visible = true
	mouse_filter = MOUSE_FILTER_STOP
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	for i in ui_scenes: 
		if is_instance_valid(i):i.visible = false
	get_tree().paused = true

	
func unpause() -> void:
	get_tree().paused = false
	visible = false
	mouse_filter = MOUSE_FILTER_IGNORE
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	for i in ui_scenes: 
		if is_instance_valid(i):i.visible = true


	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Pause"):
		if not get_tree().paused: pause()
		else: 
			unpause()


func _on_continue_button_pressed() -> void:
	unpause()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menus/scenes/menus/main_menu/main_menu_with_animations.tscn")
