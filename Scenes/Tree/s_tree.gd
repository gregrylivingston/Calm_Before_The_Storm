extends StaticBody3D

@export var health := 150
@export var max_health := 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func chop_tree():
	if health < 0:
		queue_free()
	else:
		var progress_bar = get_tree().get_first_node_in_group("ActionProgressBar")
		health -= 1
		progress_bar.value = health
		progress_bar.max_value = max_health
	
