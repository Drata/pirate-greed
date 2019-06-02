extends Position2D

var free = true
export var active = true

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		modulate = Color(0.0, 0.0, 0.0)
		active = false

func _on_Area2D_area_exited(area):
	if (area.is_in_group("player")):
		modulate = Color(0.0, 1.0, 0.0)
		active = true