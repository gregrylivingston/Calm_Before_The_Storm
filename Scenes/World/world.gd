extends Node3D

var noise = FastNoiseLite.new()
var nature_noise = FastNoiseLite.new()
var chunks: Dictionary = {}
var height_map: Dictionary = {}
var chunk_size = Vector3(64, 32, 64)
var unload_distance := 4
var load_distance := 2


@export var chunkScene := preload("res://Scenes/World/basic_chunk.tscn")
@onready var player := get_tree().get_first_node_in_group("player")

func _ready():
	setup_noise()
	call_deferred("start_round")

func start_round():
	Weather.start_new_round()


func _process(_delta):
	generate_player_chunks()
	unload_distant_chunks()
	if digRequestAmount > 0:
		completeDig(dig_target_position,digRequestAmount,isDig)

func setup_noise():
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.seed = randi()
	noise.frequency = 0.005 #0.03
	noise.fractal_octaves = 3
	noise.fractal_lacunarity = 2.0
	noise.fractal_gain = 0.5
	
	nature_noise.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	nature_noise.frequency = 0.04
	nature_noise.fractal_octaves = 3
	nature_noise.fractal_lacunarity = 2.1
	nature_noise.fractal_gain = 0.6

func generate_surrounding_chunks():
	for x in range(-1, 2):
		for z in range(-1, 2):
			generate_chunk(Vector3(x, 0, z) * chunk_size)

func generate_player_chunks():
	var player_chunk = (player.global_transform.origin / chunk_size).floor()
	for x in range(int(player_chunk.x) - load_distance + 1, int(player_chunk.x) + load_distance):
		for z in range(int(player_chunk.z) - load_distance + 1, int(player_chunk.z) + load_distance):
			var chunk_pos = Vector3(x, 0, z) * chunk_size
			if not chunks.has(chunk_pos):
				generate_chunk(chunk_pos)

func unload_distant_chunks():
	var player_chunk = (player.global_transform.origin / chunk_size).floor()
	var chunks_to_remove = []
	for chunk_pos in chunks.keys():
		var chunk_distance = chunk_pos.distance_to(player_chunk * chunk_size)
		if chunk_distance > unload_distance * chunk_size.x:
			chunks_to_remove.append(chunk_pos)
	for chunk_pos in chunks_to_remove:
		var chunk = chunks[chunk_pos]
		chunk.queue_free()
		chunks.erase(chunk_pos)

func generate_chunk(chunk_pos: Vector3):
	var isRemakingChunk := false
	if chunks.has(chunk_pos):
		chunks[chunk_pos].queue_free()
		chunks.erase(chunk_pos)
		isRemakingChunk = true
	if not height_map.has(chunk_pos):
		height_map[chunk_pos] = generate_heights(chunk_pos)
	var heights = height_map[chunk_pos]
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)
	var points = generate_points(heights, chunk_pos)
	for point in points:
		surface_tool.add_vertex(point)
	surface_tool.generate_normals()
	var newmesh = ArrayMesh.new()
	newmesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, surface_tool.commit_to_arrays())
	var chunk = chunkScene.instantiate()
	chunk.mesh = newmesh
	chunk.chunk_pos = chunk_pos
	if not isRemakingChunk: chunk.add_nature(heights , nature_noise)
	self.add_child(chunk)
	chunks[chunk_pos] = chunk
	var static_body = StaticBody3D.new()
	chunk.add_child(static_body)
	var collision_shape = CollisionShape3D.new()
	static_body.add_child(collision_shape)
	var shape = ConcavePolygonShape3D.new()
	shape.set_faces(surface_tool.commit_to_arrays()[Mesh.ARRAY_VERTEX])
	collision_shape.shape = shape

func generate_heights(chunk_pos: Vector3) -> Array:
	var heights = []
	for z in range(chunk_size.z + 1):
		var row = []
		for x in range(chunk_size.x + 1):
			var world_x = x + chunk_pos.x
			var world_z = z + chunk_pos.z
			var height = (noise.get_noise_2d(world_x, world_z) + 1.0) * chunk_size.y
			if height < 0:
				height = 0
			row.append(height)
		heights.append(row)
	return heights

func generate_points(heights: Array, chunk_pos: Vector3) -> Array:
	var points = []
	for z in range(chunk_size.z):
		for x in range(chunk_size.x):
			points.append(Vector3(x,     heights[z][x],     z)     + chunk_pos)
			points.append(Vector3(x + 1, heights[z][x + 1], z)     + chunk_pos)
			points.append(Vector3(x,     heights[z + 1][x], z + 1) + chunk_pos)
			points.append(Vector3(x + 1, heights[z][x + 1], z)     + chunk_pos)
			points.append(Vector3(x + 1, heights[z + 1][x + 1], z + 1) + chunk_pos)
			points.append(Vector3(x,     heights[z + 1][x], z + 1) + chunk_pos)
	return points

var digRequestAmount := 0.0
var dig_target_position: Vector3
var isDig: bool


	
func dig(dig_position: Vector3, amount: float, isDigging: bool = true):
	dig_target_position = dig_position
	digRequestAmount += amount * Player.data.upgrade.Dig_Strength
	isDig = isDigging
	
var digQualityDivisor := 20.0
func completeDig(dig_position: Vector3, amount: float, isDigging: bool = true):
	var chunk_pos = (dig_position / chunk_size).floor() * chunk_size
	chunk_pos.y = 0
	if height_map.has(chunk_pos):
		var heights = height_map[chunk_pos]
		var local_pos = (dig_position - chunk_pos)
		var x = int(local_pos.x)
		var z = int(local_pos.z)
		var y = int(local_pos.y)
		if y < heights[z][x]:  # Only dig if the y-coordinate of the dig_position is below the current height
			if isDigging: 
				heights[z][x] = max(heights[z][x] - amount/digQualityDivisor, -20)
				Inventory.dirt += amount * Player.data.upgrade.Dirt_Gathered
			elif Inventory.dirt > amount: 
				Inventory.dirt -= amount
				var digAmount = amount / ( 15 * digQualityDivisor )
				heights[z][x] =  heights[z][x] + digAmount * 3 
				heights[z][x+1] = heights[z][x+1] + digAmount * 2
				heights[z][x-1] = heights[z][x-1] + digAmount * 2
				heights[z+1][x] = heights[z+1][x] + digAmount * 2
				heights[z-1][x] = heights[z-1][x] + digAmount * 2
				heights[z+1][x+1] = heights[z+1][x+1] + digAmount
				heights[z-1][x-1] = heights[z-1][x-1] + digAmount
				heights[z+1][x-1] = heights[z+1][x-1] + digAmount
				heights[z-1][x+1] = heights[z-1][x+1] + digAmount
			Inventory.update_inventory.emit()

			height_map[chunk_pos] = heights  # Save the changes to the height map.
			generate_chunk(chunk_pos)  # Regenerate the chunk to show the changes.
	digRequestAmount = 0
