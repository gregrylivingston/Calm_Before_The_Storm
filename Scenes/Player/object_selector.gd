extends Area3D

var selectedObject: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
			
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
			if overlapping_body.type == type:
				return overlapping_body
	return null
