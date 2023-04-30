extends Area

export var jump_strength = 4

func _on_JumpPad_body_entered(body):
	if body.name == "Marble":
		var rot = Global.get_current_rot().normalized()*jump_strength
		body.set_axis_velocity(rot)
