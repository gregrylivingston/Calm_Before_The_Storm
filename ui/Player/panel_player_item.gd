extends Panel


var resource: PlayerItem
var inventoryPosition: int
var previousQuantity: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Label_InvPosition.text = str(inventoryPosition + 1)
	$TextureRect.texture = resource.icon

	
func update_inventory(quant: int) -> void:
	if previousQuantity != quant:
		%Label_ChangeInQuantity.modulate.a = 4.0
		if quant - previousQuantity > 0:
			%Label_ChangeInQuantity.text = "+" + str(quant - previousQuantity)
		else:
			%Label_ChangeInQuantity.text = str(quant - previousQuantity)

		%LabelQuantity.text = "x" + str(quant)
		previousQuantity = quant
		process_mode = PROCESS_MODE_INHERIT

		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_fade_out()
		
func _fade_out() -> void:
	if %Label_ChangeInQuantity.modulate.a > 0:
		%Label_ChangeInQuantity.modulate.a -= 0.05
	else:
		process_mode = PROCESS_MODE_DISABLED
