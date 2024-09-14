extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Player.data.isLowGraphicsMode:
		button_pressed = true
		text = "Simple Graphics"
	else:
		text = "Complex Graphics"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if not Player.data.isLowGraphicsMode:
		text = "Simple Graphics"
		Player.data.isLowGraphicsMode = true
	else:
		text = "Complex Graphics"
		Player.data.isLowGraphicsMode = false
	Player.save_game()
