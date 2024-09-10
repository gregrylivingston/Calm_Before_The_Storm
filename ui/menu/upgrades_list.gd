extends VBoxContainer

var item_upgrade_hbox = load("res://ui/Player/hbox_upgrade_item.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for upgrade in Player.data.upgrade:
		var newBox = item_upgrade_hbox.instantiate()
		newBox.title = upgrade
		add_child(newBox)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
