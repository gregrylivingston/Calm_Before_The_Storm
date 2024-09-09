extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta: float) -> void:
	if false:
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)

		move_and_slide()


@export var health := 100
@export var max_health := 100

@export var meat_to_award := 10

func is_animal() -> bool:return true

func chop_tree():
	if health < 0:
		Inventory.meat += meat_to_award
		Inventory.update_inventory.emit()
		queue_free()
	else:
		var progress_bar = get_tree().get_first_node_in_group("ActionProgressBar")
		health -= 1
		progress_bar.value = health
		progress_bar.max_value = max_health
		
func grabbed():
	set_collision_layer_value(1,0)
	set_collision_layer_value(4,0)
	set_collision_mask_value(4,0)
	set_collision_mask_value(1,0)
