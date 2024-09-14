extends Node

@onready var button_click_sound : AudioStreamPlayer = AudioStreamPlayer.new()
@onready var button_hover_sound : AudioStreamPlayer = AudioStreamPlayer.new()

func _ready()->void:
	call_deferred("_finish_setup")
	await get_tree().create_timer(1)

func _finish_setup() -> void:
	add_child(button_click_sound)
	add_child(button_hover_sound)
	button_click_sound.volume_db = 10
	button_click_sound.stream = load("res://sound/interface/sound_interface_click.mp3")
	button_hover_sound.stream = load("res://sound/interface/sound_interface_hover.mp3")
	connect_buttons()

func connect_buttons() -> void:
	var buttons: Array = get_tree().get_nodes_in_group("Button")
	for inst in buttons:
		if not inst.is_connected("pressed", on_button_pressed):inst.connect("pressed", on_button_pressed)
		if not inst.is_connected("mouse_entered", on_button_hover):inst.connect("mouse_entered", on_button_hover)
		
func on_button_pressed()->void:
	button_click_sound.play()
	
func on_button_hover() -> void:
	button_hover_sound.play()
