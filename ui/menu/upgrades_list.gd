extends VBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in Player.data.upgrade:
		var title = upgrade.replace("_"," ")
		var value = Player.data.upgrade[upgrade]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
