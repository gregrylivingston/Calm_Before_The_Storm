extends ProgressBar

var displayTimer := 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	displayTimer = displayTimer - delta
	if displayTimer < 0:
		visible = false


func _on_value_changed(value: float) -> void:
	visible = true
	displayTimer = 0.5
