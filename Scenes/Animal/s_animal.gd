class_name Animal3D extends CharacterBody3D

enum Types { Fruit, Hay, Meat}
@export var resource: AnimalResource
@export var health := 100
@export var max_health := 100
@onready var animationPlayer = get_child(0).get_child(1) as AnimationPlayer
@export var meat_to_award := 1
var isDead := false
var isPlacedInBuilding:= false
var myName : String = NameGenerator.get_random_name()

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
	animationPlayer.current_animation = "AnimalArmature|Death"
	animationPlayer.play()
	$AudioStreamPlayer3D.finished.connect(_destroy_animal_scene)
		
func _destroy_animal_scene() -> void:
	queue_free()

func play_basic_sound() -> void:
	$AudioStreamPlayer3D.stream = resource.sound_basic
	$AudioStreamPlayer3D.play(0)
	
func place_in_building() -> void:
	isPlacedInBuilding = true
	$AudioStreamPlayer3D.stream = resource.sound_happy
	$AudioStreamPlayer3D.play(0)
	
func grabbed():
	set_collision_layer_value(1,0)
	set_collision_layer_value(4,0)
	set_collision_mask_value(4,0)
	set_collision_mask_value(1,0)
	
## Fired when the animal has been picked up but needs to be dropped.
func place_building() -> void: 
	set_collision_layer_value(1,1)
	set_collision_layer_value(4,1)
	set_collision_mask_value(4,1)
	set_collision_mask_value(1,1)


	
