extends RigidBody

export var rotSpeed = 1.0

func _process(delta):
	var rotChange = Vector3(0,0,0)
	
	if Input.is_action_pressed("rot_left"):
		rotChange += Vector3(0,0,1)
	if Input.is_action_pressed("rot_right"):
		rotChange += Vector3(0,0,-1)
	if Input.is_action_pressed("rot_up"):
		rotChange += Vector3(-1,0,0)
	if Input.is_action_pressed("rot_down"):
		rotChange += Vector3(1,0,0)
	
	rotChange = rotChange.normalized()

	rotate_object_local(Vector3(0,0,1),rotSpeed * delta * rotChange.z)
	rotate_object_local(Vector3(1,0,0),rotSpeed * delta * rotChange.x)
	
	#limit rotation along x,z and lock along y
	var myRot = get_rotation()
	rotation = Vector3(clamp(myRot.x, -.2, .2), 0, clamp(myRot.z, -.2, .2))
