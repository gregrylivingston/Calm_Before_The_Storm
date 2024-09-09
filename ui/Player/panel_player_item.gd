extends Panel


var resource: PlayerItem
var inventoryPosition: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label_InvPosition.text = str(inventoryPosition + 1)
	$TextureRect.texture = resource.icon

	
func update_inventory(quant: int) -> void:
	%LabelQuantity.text = "x" + str(quant)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
