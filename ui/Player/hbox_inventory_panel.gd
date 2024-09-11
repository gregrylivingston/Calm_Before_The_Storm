extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	call_deferred("add_panel_items")
	Inventory.update_inventory.connect(_update_inventory)

var itempanelscene = load("res://ui/Player/panel_player_item.tscn")
var loadedItems := 0
func add_panel_items():
	for item in get_tree().get_first_node_in_group("player").player_item_options:
		var newPanel = itempanelscene.instantiate()
		newPanel.resource = item
		newPanel.inventoryPosition = loadedItems
		add_child(newPanel)
		move_child(newPanel, loadedItems+1)
		loadedItems+=1
	_update_inventory()
		
func _update_inventory() -> void:
	get_child(1).update_inventory(Inventory.wood)
	get_child(2).update_inventory(Inventory.dirt)
	get_child(3).update_inventory(Inventory.stone)
	get_child(4).update_inventory(Inventory.fruit)
	get_child(5).update_inventory(Inventory.hay)
	get_child(6).update_inventory(Inventory.meat)
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
