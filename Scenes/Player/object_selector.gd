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
			
func do_action():
	for overlapping_body in get_overlapping_bodies():
		if overlapping_body.has_method("handle_collision"):
			overlapping_body.handle_collision()
