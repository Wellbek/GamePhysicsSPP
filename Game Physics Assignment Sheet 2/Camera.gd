extends Camera

var transSpeed = 10
var rotSpeed = 1

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
		
	change = change.normalized()
		
	transform = transform.translated(change * delta * transSpeed)
	
	if Input.is_action_pressed("rot_left"):
		rotate(Vector3(0,1,0),rotSpeed * delta)
	if Input.is_action_pressed("rot_right"):
		rotate(Vector3(0,-1,0),rotSpeed * delta)
	if Input.is_action_pressed("rot_up"):
		rotate_object_local(Vector3(1,0,0),rotSpeed * delta)
	if Input.is_action_pressed("rot_down"):
		rotate_object_local(Vector3(-1,0,0),rotSpeed * delta)


