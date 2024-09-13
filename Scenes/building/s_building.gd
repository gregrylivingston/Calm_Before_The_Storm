class_name Building3D extends StaticBody3D

## number of animals the building can hold
@export var max_slots := 4
## number of animals in the building
@export var used_slots := 0
## animal types accepted by the building
@export var type: Animal3D.Types
@export var wood_cost := 0

@export var icon: Texture2D
@export var placement_position: Array[Node3D]
@export var instructions: String
@export var title: String

func _ready() -> void:
	$BuildingIndicator/Sprite3D.texture = icon

func drown() -> void:
	remove_from_group(title)  #prevents star awards and building-count detection
	set_collision_layer_value(3,false)  #prevents repeated collisions with water.
	Alert.send_alert("A " + title + " has drowned.")
	Player.farm_building_updates.emit()

func is_building() -> bool: return true

func place_building() -> void:
	set_collision_layer_value(1,true)
	set_collision_layer_value(3,true)
	set_collision_layer_value(5, true)
	
func add_animal(animal: Animal3D) -> bool:
	if used_slots < max_slots:
		animal.global_position = placement_position[used_slots].global_position
		animal.rotation = placement_position[used_slots].rotation
		animal.place_in_building()
		used_slots += 1
		$BuildingIndicator.get_child(0).queue_free()
		if used_slots == max_slots:_building_is_filled()
		return true
	else: 
		return false
		
func _building_is_filled() -> void:
	$BuildingIndicator.visible = false
	var timeBonus: int = 8 + 2 * Player.data.upgrade.Full_Building_Bonus
	Weather.state_timer -= timeBonus
	Alert.send_time_bonus(timeBonus)
	call_deferred("_delayed_alert")
	
func _delayed_alert() -> void:
	Alert.send_alert("Building Filled, Storm Delayed")

		
func _physics_process(delta: float) -> void:
	$BuildingIndicator.rotation.y += 0.01
