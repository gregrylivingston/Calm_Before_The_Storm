extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("add_panel_items")

var itempanelscene = load("res://ui/Player/panel_player_item.tscn")
var loadedItems := 0
func add_panel_items():
	for item in get_tree().get_first_node_in_group("player").player_item_options:
		var newPanel = itempanelscene.instantiate()
		newPanel.resource = item
		newPanel.inventoryPosition = loadedItems
		add_child(newPanel)
		loadedItems+=1
		
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
