class_name Building3D extends StaticBody3D

@export var max_slots := 4
@export var used_slots := 0

@export var placement_position: Array[Node3D]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func is_building() -> bool: return true

func place_building() -> void:
	set_collision_layer_value(1,true)
	set_collision_layer_value(5, true)
	
func add_animal(animal: Animal3D) -> bool:
	if used_slots < max_slots:
		animal.global_position = placement_position[used_slots].global_position
		animal.rotation = placement_position[used_slots].rotation
		used_slots += 1
		return true
	else: 
		return false
