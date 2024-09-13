class_name Animal3D extends CharacterBody3D

enum Types { Fruit, Hay, Meat}
@export var resource: AnimalResource
@export var health := 100
@export var max_health := 100
@export var meat_to_award := 1
var isDead := false
var isPlacedInBuilding:= false
var myName : String = NameGenerator.get_random_name()
@export var AnimalMeshInstance: MeshInstance3D
@export var AnimalAnimationPlayer: AnimationPlayer
@export var food_demand: int = 1

func _ready() -> void:
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.95,1.05)
	if is_instance_valid(AnimalMeshInstance) && OS.get_name() == "Web":
		AnimalMeshInstance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

func is_animal() -> bool:return true

#this is what happens if you attack / kill the animal...
func chop_tree():
	if isPlacedInBuilding: pass
	elif health < 0 && not isDead:
		_die()
	elif isDead:
		pass
	else:
		var progress_bar = get_tree().get_first_node_in_group("ActionProgressBar")
		health -= 1 * Player.data.upgrade.Chop_Strength
		progress_bar.value = health
		progress_bar.max_value = max_health
		
func _die() -> void:
	isDead = true
	
	if meat_to_award > 0:
		Inventory.meat += meat_to_award * Player.data.upgrade.Meat_Gathered
		Inventory.update_inventory.emit()
	$AudioStreamPlayer3D.stream = resource.sound_sad
	$AudioStreamPlayer3D.play()
	if is_instance_valid(AnimalAnimationPlayer):
		AnimalAnimationPlayer.current_animation = "AnimalArmature|Death"
		AnimalAnimationPlayer.play()
	$AudioStreamPlayer3D.finished.connect(_destroy_animal_scene)
		
func _destroy_animal_scene() -> void:
	queue_free()

func play_basic_sound() -> void:
	$AudioStreamPlayer3D.stream = resource.sound_basic
	$AudioStreamPlayer3D.play(0)
	
func place_in_building() -> void:
	isGrabbed = false
	AnimalMeshInstance.set_material_override(null)
	isPlacedInBuilding = true
	$AudioStreamPlayer3D.stream = resource.sound_happy
	$AudioStreamPlayer3D.play(0)
	
var isGrabbed := false
func grabbed():
	play_basic_sound()
	AnimalMeshInstance.material_overlay = load("res://material/material_animal3dshine.tres")
	set_collision_layer_value(1,0)
	set_collision_layer_value(4,0)
	set_collision_mask_value(4,0)
	set_collision_mask_value(1,0)
	isGrabbed = true
	
## Fired when the animal has been picked up but needs to be dropped.
func place_building() -> void: 
	set_collision_layer_value(1,1)
	set_collision_layer_value(4,1)
	set_collision_mask_value(4,1)
	set_collision_mask_value(1,1)

func drop_animal() -> void:
	if AnimalMeshInstance.material_overlay != null:
		AnimalMeshInstance.material_overlay = null
	set_collision_layer_value(1,1)
	set_collision_layer_value(4,1)
	set_collision_mask_value(4,1)
	set_collision_mask_value(1,1)
	isGrabbed = false
	


	

	
