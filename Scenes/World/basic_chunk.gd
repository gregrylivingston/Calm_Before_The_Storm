extends MeshInstance3D

var chunk_pos: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("_deferred_ready")

var waterScene = load("res://Scenes/World/mesh_instance_water.tscn")
func _deferred_ready() -> void:
	var newWaterScene = waterScene.instantiate()
	newWaterScene.position = Vector3(chunk_pos.x,-1,chunk_pos.z)  ## this results in later spawning water having a bad rando height
	get_parent().add_child(newWaterScene)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
	
var pinetreescene = load("res://Scenes/Tree/s_tree_appletree.tscn")


@export var low_elevation_plants : Array[PackedScene]
@export var medium_elevation_plants : Array[PackedScene]
@export var high_elevation_plants : Array[PackedScene]


func add_nature(heights: Array, nature_noise) -> void:
	call_deferred("_deferred_add_nature",heights,nature_noise)


func _deferred_add_nature(heights: Array, nature_noise) -> void:
	for z in 64:
		for x in 64:
			var height = heights[z][x]
			var nature_list: Array[PackedScene]
			var spawn_bias: float = 0.0
			if height < 25: 
				nature_list = low_elevation_plants
				spawn_bias = 0.03
			elif height < 45: 
				nature_list = medium_elevation_plants
				spawn_bias = 0.02
			else: 
				nature_list = high_elevation_plants
				spawn_bias = 0.01

			if OS.get_name() == "Web":
				spawn_bias = spawn_bias / 8.0
			
			var noiseValue = nature_noise.get_noise_2d(x + chunk_pos.x, z + chunk_pos.z)
			var noiseInt: int = int(noiseValue * nature_list.size())
			## normalize noise value to the size of the nature list array....
			
			
			if randf() < ( spawn_bias ): ## include the 4x divisor for web export
				
				
				#print(height) # 40 / 1000: 0.04
				var newScene = nature_list[noiseInt].instantiate()
				newScene.position = Vector3(x,height ,z) + chunk_pos + Vector3(randf_range(-1,1),0,randf_range(-1,1))
				newScene.rotation.y = randf_range(0,3.14)
				newScene.scale = newScene.scale * randf_range(0.7,1.3)
				get_parent().add_child(newScene)
			if x % 32 == 0:
				if is_instance_valid(get_tree()):
					await get_tree().process_frame

				
				 
