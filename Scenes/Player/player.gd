extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var speed = 4.0
var defaultSpeed = 4.0
var sprintSpeed = 25.0
var jump_speed = 11.0
var mouse_sensitivity = 0.002
var actionPressed = false

var drowned := false

@onready var raycast := %RayCast3D
@onready var world := $/root/main/map

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func get_input():
	if not drowned:
		var input = Input.get_vector("strafe_left", "strafe_right", "move_forward", "move_back")
		var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
		velocity.x = movement_dir.x * speed
		velocity.z = movement_dir.z * speed

func _physics_process(delta):
	doAction()
	select_item_check()
	velocity.y += -gravity * delta
	get_input()
	move_and_slide()

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
	if event.is_action_pressed("jump") and is_on_floor():
		velocity.y = jump_speed

#returns true if able to break earth
func breakBlocks() -> bool:
	if raycast.is_colliding():
		if raycast.get_collider() is StaticBody3D:
			var collider = raycast.get_collider()
			var collisionPoint = raycast.get_collision_point()
			var particleScene := preload("res://Scenes/player/mining_particles.tscn")
			var particles := particleScene.instantiate()
			particles.position = collisionPoint
			world.add_child(particles)
			particles.emitting = true
			world.dig(collisionPoint, 1)
			return true
	return false

		
func doAction():
	if actionPressed:
		if not breakBlocks():
			%ObjectSelector.do_action()

func drown() -> void:
	$Camera3D/UnderwaterView.visible = true
	$Camera3D/UnderwaterView/Canvas_GameOver.visible = true
	drowned = true
	%Gear. visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	$Camera3D/Canvas_RainEffects.visible = false
	$Camera3D/CanvasUI.visible = false
	velocity.x = 0
	velocity.z = 0
	
var is_secondary_use_mode := false
@export var player_item_options : Array[PlayerItem]
func select_item_check() -> void:
	if Input.is_action_just_pressed("1"):select_new_item(0)
	if Input.is_action_just_pressed("2"):select_new_item(1)
	if Input.is_action_just_pressed("3"):select_new_item(2)
	

func select_new_item(ItemInt: int) -> void:
	for i in %Gear.get_children(): i.queue_free()
	var newItemResource = player_item_options[ItemInt]
	var newItemScene = newItemResource.scene.instantiate()
	%Gear.add_child(newItemScene)
	newItemScene.rotation_degrees.y = -90
	newItemScene.rotation_degrees.z = 3.7
	newItemScene.position = Vector3(0.56,-.23,-.8) 
