extends RigidBody


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("-------------")
	print("lv: ",linear_velocity)
	print("av: ",angular_velocity)
	print("pos: ", transform.origin)
	print("rot: ", get_rotation_degrees())
