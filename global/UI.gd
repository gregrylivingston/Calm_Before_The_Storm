extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var left_mouse_icon: Control
func set_left_mouse_action_text(text: String) -> void:
	left_mouse_icon.set_left_mouse_action_text(text)
	
var right_mouse_icon: Control
func set_right_mouse_action_text(text: String) -> void:
	right_mouse_icon.set_right_mouse_action_text(text)
