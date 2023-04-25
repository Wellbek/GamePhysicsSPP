extends RigidBody

var rotSpeed = .3 # NOTE: Higher values than 0.3 will lead to tunneling (object passing through collider)
export var mouseSpeed = 2.0
export var clickOrigin = Vector2(0,0)

func _physics_process(delta):
	# ======================================
	# Arrowkeys Rotation:
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
	# ======================================
	# Mouse Rotation:
	# NOTE: Tunneling!
	#		simply clamping mouseSpeed and/or clickVector wont resolve the issue as in the arrow key case
	if Input.is_action_just_pressed("unlock_camera"):
		clickOrigin = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("unlock_camera"):
		var clickVec = get_viewport().get_mouse_position() - clickOrigin
		clickOrigin = get_viewport().get_mouse_position()
		clickVec = clickVec/10
		rotate_object_local(Vector3(0,0,1),mouseSpeed * delta * -clickVec.x)
		rotate_object_local(Vector3(1,0,0),mouseSpeed * delta * clickVec.y)
	# ======================================
	
	#limit rotation along x,z and lock along y
	var myRot = get_rotation()
	rotation = Vector3(clamp(myRot.x, -.2, .2), 0, clamp(myRot.z, -.2, .2))
