extends MeshInstance3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	position.y = -100
	Water.height_change.connect(height_change)
	Weather.new_round.connect(newround)
	if OS.get_name() != "Web" || Player.data.isLowGraphicsMode:
		set_surface_override_material(0, null)

func newround() -> void:
	height_change(-100)

func height_change(newHeight: float) -> void:
	position.y = newHeight

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.has_method("drown"):body.drown()

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.has_method("drown"):area.drown()
