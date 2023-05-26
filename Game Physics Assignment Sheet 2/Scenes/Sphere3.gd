extends RigidBody

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print("Pos:", transform.origin)
	print("lv:", linear_velocity)
	print("av:", angular_velocity)
	print("Rot:", rotation_degrees)
	print("----------------------")
