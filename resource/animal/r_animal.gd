class_name AnimalResource extends Resource

@export var sound_basic: AudioStream
@export var sound_happy: AudioStream
@export var sound_sad: AudioStream

@export var title: String
@export var group_title: String
@export var type: Animal3D.Types

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
