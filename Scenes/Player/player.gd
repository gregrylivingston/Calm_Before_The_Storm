extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0
var defaultSpeed = 4.0
var sprintSpeed = 8.0 + Player.data.upgrade.Sprint_Speed
var jump_speed = 5.0 + Player.data.upgrade.Jump_Height
var mouse_sensitivity = 0.002
var actionPressed := false
var rightClickPressed := false

var drowned := false

@onready var raycast := %RayCast3D
@onready var world := $/root/main/map

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	select_new_item(0)

func get_input():
	if not drowned:
		var input = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
		var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed

func _process(delta: float) -> void:
	_process_animation_audio()


func _process_animation_audio() -> void:
	if %Gear.rotation_degrees.x > 15 && $AudioStream_Axe.playing == false && selected_item_int == 0:
		$AudioStream_Axe.play()

func _physics_process(delta):
	doAction()
	rightClick()
	select_item_check()
	velocity.y += -gravity * delta
	get_input()
	move_and_slide()
	move_queued_building()
	draw_grabbed_animal_connection()
	draw_grabbed_building_connection()

func _unhandled_input(event):
	if event.is_action_pressed("action"):
		$AnimationPlayer.play("swing")
		actionPressed = true
	if event.is_action_released("action"):
		$AnimationPlayer.stop()
		actionPressed = false
	if event.is_action_pressed("sprint"):
		speed = sprintSpeed
	if event.is_action_released("sprint"):
		speed = defaultSpeed
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED && not drowned:
		rotate_y(-event.relative.x * mouse_sensitivity)
		%Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		%Camera3D.rotation.x = clampf(%Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
	handle_controller_right_stick_input(event)
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

func handle_controller_right_stick_input(event) -> void:
	# Horizontal rotation (Y-axis)
	var right_stick_x = Input.get_action_strength("look_left") - Input.get_action_strength("look_right")
	rotate_y(right_stick_x * .05 )

	# Vertical rotation (X-axis)
	var right_stick_y = Input.get_action_strength("look_down") - Input.get_action_strength("look_up")
	%Camera3D.rotate_x(-right_stick_y * .1)

	# Clamp the vertical rotation to avoid over-rotation (up/down look limit)
	%Camera3D.rotation.x = clamp(%Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))


#returns true if able to break earth
func digEarth(isDigging: bool = true) -> bool:
	%RayCast3D.target_position.z = -5
	if raycast.is_colliding():
		if raycast.get_collider() is StaticBody3D:
			var collider = raycast.get_collider()
			var collisionPoint = raycast.get_collision_point()
			var particleScene = preload("res://Scenes/Player/mining_particles.tscn")
			var particles = particleScene.instantiate()
			particles.position = collisionPoint
			world.add_child(particles)
			particles.emitting = true
			world.dig(collisionPoint, 1, isDigging)
			return true
	return false

		
func doAction():
	if actionPressed:
		if is_instance_valid(queued_buildable_object):
			_place_queued_building()
		else:
			match selected_item_int:
				1:digEarth(true)
				0:%ObjectSelector.chop_tree()
				2:%ObjectSelector.break_rock()


func rightClick():
	match selected_item_int:
		1:if Input.is_action_pressed("alt_action"):digEarth(false)
		0:if Input.is_action_just_pressed("alt_action"):_select_next_wood_building()
		2:pass
		3:grab_animal(Animal3D.Types.Fruit)
		4:grab_animal(Animal3D.Types.Hay)
		5:grab_animal(Animal3D.Types.Meat)
	

var queued_buildable_object: Node3D = null


func grab_animal(type: Animal3D.Types) -> void:
	if Input.is_action_just_pressed("alt_action"):
		
		queued_buildable_object = %ObjectSelector.grab_animal(type)
		if is_instance_valid(queued_buildable_object):
			queued_buildable_object.grabbed()
			Alert.send_alert("You grabbed " + queued_buildable_object.myName + " the " + queued_buildable_object.resource.title)
			match type:
				Animal3D.Types.Fruit:
					Inventory.fruit -= queued_buildable_object.food_demand
				Animal3D.Types.Hay:
					Inventory.hay -= queued_buildable_object.food_demand
				Animal3D.Types.Meat:
					Inventory.meat -= queued_buildable_object.food_demand
			Inventory.update_inventory.emit()
			Ui.set_left_mouse_action_text("Release")
			Ui.set_right_mouse_action_text("")
		
			

func reset_active_item() -> void:
	select_new_item(1)


var wood_building_num := -1
@export var wood_buildings: Array[PackedScene]
func _select_next_wood_building() -> void:
	Ui.set_left_mouse_action_text("Place Building")
	if is_instance_valid(queued_buildable_object):queued_buildable_object.queue_free()
	wood_building_num += 1
	if wood_building_num > wood_buildings.size() - 1: wood_building_num = 0
	var newBuilding = wood_buildings[wood_building_num].instantiate()
	queued_buildable_object = newBuilding
	Alert.send_instruction(newBuilding.instructions)
	get_parent().add_child(newBuilding)
	
#this also handles movement for animals
func move_queued_building() -> void:
	if is_instance_valid(queued_buildable_object):
		%RayCast3D.target_position.z = -6 - Player.data.upgrade.Hold_Distance * 2
		if raycast.is_colliding():
			var collider = raycast.get_collider()
			if collider is StaticBody3D:
				queued_buildable_object.position = raycast.get_collision_point()
				
				if collider.has_method("is_building") && queued_buildable_object.has_method("is_animal"):
					_attempt_to_place_queued_animal(collider , queued_buildable_object)
		else:
			var target_global_position = raycast.to_global(raycast.target_position)
			queued_buildable_object.position = target_global_position

func _attempt_to_place_queued_animal( building: StaticBody3D, animal: Animal3D) -> void:
	if building.type == animal.resource.type:
		if building.add_animal(animal): ## this function returns false if building is full
			_place_queued_animal(building, animal)
		else:
			Alert.send_alert("This " + building.title + " is full.")
			animal.play_basic_sound()
	else:
		animal.play_basic_sound()
		Alert.send_alert(building.title + "s don't take " + animal.resource.group_title)


func _place_queued_animal(building: StaticBody3D, animal: Animal3D) -> void:
		Alert.send_alert("You saved " + animal.myName + " the " + animal.resource.title)
		queued_buildable_object = null
		match animal.resource.type:
			Animal3D.Types.Fruit:
				if Inventory.fruit < 1: select_new_item(1)
			Animal3D.Types.Hay:
				if Inventory.hay < 1: select_new_item(1)
			Animal3D.Types.Meat:
				if Inventory.meat < 1: select_new_item(1)
		Player.farm_building_updates.emit()

	

func _place_queued_building() -> void:
	if queued_buildable_object.has_method("is_animal"):
		queued_buildable_object.drop_animal()
		queued_buildable_object = null
	elif queued_buildable_object.has_method("is_building"):
		if queued_buildable_object.wood_cost <= Inventory.wood:
			queued_buildable_object.place_building()
			Inventory.wood -= queued_buildable_object.wood_cost
			Inventory.update_inventory.emit()
			Player.farm_building_updates.emit()
			queued_buildable_object = null
		else:
			Alert.send_alert("Not Enough Wood.")


	select_item_check()

func drown() -> void:
	$Camera3D/UnderwaterView.visible = true
	$Camera3D/UnderwaterView/Canvas_GameOver.endGame()
	if not drowned:
		drowned = true
		Player.data.stars += Inventory.stars
		%Gear. visible = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$Camera3D/Canvas_RainEffects.visible = false
		$Camera3D/CanvasUI.visible = false
		$AudioStreamPlayer2D.stream = load("res://sound/music_queue/drowned_Heavy_ConceptB.wav")
		$AudioStreamPlayer2D.play()
	velocity.x = 0
	velocity.z = 0
	
var is_secondary_use_mode := false
@export var player_item_options : Array[PlayerItem]
var selected_item_int := 0
func select_item_check() -> void:
	if Input.is_action_just_pressed("1"):
		select_new_item(0)
	if Input.is_action_just_pressed("2"):
		select_new_item(1)
	if Input.is_action_just_pressed("3"):
		select_new_item(2)
	if Input.is_action_just_pressed("4"):
		if Inventory.fruit > 0: select_new_item(3)
		else: Alert.send_alert("No Fruit.")
	if Input.is_action_just_pressed("5"):
		if Inventory.hay > 0: select_new_item(4)
		else: Alert.send_alert("No Hay.")
	if Input.is_action_just_pressed("6"):
		if Inventory.meat > 0: select_new_item(5)
		else: Alert.send_alert("No Meat.")


func select_new_item(ItemInt: int) -> void:
	if is_instance_valid(queued_buildable_object):
		if queued_buildable_object.has_method("drop_animal"):
			queued_buildable_object.drop_animal()
			queued_buildable_object = null
		else: queued_buildable_object.queue_free() #cancels building
	selected_item_int = ItemInt
	for i in %Gear.get_children(): i.queue_free()
	var newItemResource = player_item_options[ItemInt]
	
	Ui.set_left_mouse_action_text(newItemResource.left_action_string)
	Ui.set_right_mouse_action_text(newItemResource.right_action_string)
	var newItemScene = newItemResource.scene.instantiate()
	%Gear.add_child(newItemScene)
	newItemScene.rotation_degrees.y = -90
	newItemScene.rotation_degrees.z = 3.7
	newItemScene.position = Vector3(0.56,.23,-.8) 
	
func draw_grabbed_animal_connection():
	if is_instance_valid(queued_buildable_object):
		if queued_buildable_object.has_method("is_animal"):
			if queued_buildable_object.isGrabbed:
				DebugDraw3D.draw_line(global_position, queued_buildable_object.global_position, Color(1, 1, 0))

func draw_grabbed_building_connection():
	if is_instance_valid(queued_buildable_object):
		if queued_buildable_object.has_method("is_building"):
			DebugDraw3D.draw_line(global_position, queued_buildable_object.global_position, Color(1, 1, 0))
