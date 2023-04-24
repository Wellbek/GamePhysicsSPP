extends Camera

var transSpeed = 10
var rotSpeed = 1
var mouseSpeed = 2
var clickOrigin = Vector2(0,0)

func _process(delta):
	var change = Vector3(0,0,0)
	var rotChange = Vector3(0,0,0)
	
	if Input.is_action_pressed("left"):
		change.x -= 1
	if Input.is_action_pressed("right"):
		change.x += 1
	if Input.is_action_pressed("forward"):
		change.z -= 1
	if Input.is_action_pressed("back"):
		change.z += 1
	if Input.is_action_pressed("up"):
		change.y += 1
	if Input.is_action_pressed("down"):
		change.y -= 1
		
	change = change.normalized()
		
	transform = transform.translated(change * delta * transSpeed)
	
	if Input.is_action_pressed("rot_left"):
		rotChange += Vector3(0,1,0)
	if Input.is_action_pressed("rot_right"):
		rotChange += Vector3(0,-1,0)
	if Input.is_action_pressed("rot_up"):
		rotChange += Vector3(1,0,0)
	if Input.is_action_pressed("rot_down"):
		rotChange += Vector3(-1,0,0)
	
	rotChange = rotChange.normalized()

	rotate(Vector3(0,1,0),rotSpeed * delta * rotChange.y)
	rotate_object_local(Vector3(1,0,0),rotSpeed * delta * rotChange.x)
	
	if Input.is_action_just_pressed("unlock_camera"):
		clickOrigin = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("unlock_camera"):
		var clickVec = get_viewport().get_mouse_position() - clickOrigin
		clickOrigin = get_viewport().get_mouse_position()
		clickVec = clickVec/10
		rotate(Vector3(0,1,0),mouseSpeed * delta * -clickVec.x)
		rotate_object_local(Vector3(1,0,0),mouseSpeed * delta * -clickVec.y)
		

