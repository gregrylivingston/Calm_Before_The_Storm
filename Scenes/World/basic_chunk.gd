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
	
	
var pinetreescene = load("res://animal/FBX2/Cow.fbx")

func add_nature(heights: Array, nature_noise) -> void:
	call_deferred("_deferred_add_nature",heights,nature_noise)


func _deferred_add_nature(heights: Array, nature_noise) -> void:
	for z in 64:
		for x in 64:
			var noiseValue = nature_noise.get_noise_2d(x + chunk_pos.x, z + chunk_pos.z)
			if noiseValue > 0.5 &&  noiseValue < 0.7 && randf() > 0.9:
				var newPine = pinetreescene.instantiate()
				get_parent().add_child(newPine)
				newPine.position = Vector3(x,heights[z][x] ,z) + chunk_pos
	
				
				 
