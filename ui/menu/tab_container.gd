extends TabContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_tab_hovered(tab: int) -> void:
	%AudioStreamPlayer_TabButtonHover.play()


func _on_tab_clicked(tab: int) -> void:
	%AudioStreamPlayer_TabButtonClick.play()
