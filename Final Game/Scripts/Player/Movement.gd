extends KinematicBody

export var movement_speed = 10.0
export var jump_strength = 10.0
export var gravity = -.2
export var mouse_sens = 5.0
var clickVec = Vector2(0,0)
var velocity = Vector3(0,0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #locks mouse to the center of screen
	#Input.set_use_accumulated_input(false) #makes Input events emit as often as possible => smoother rotation
	
func _input(event):
	if event is InputEventMouseMotion:
		clickVec = event.relative*0.001 # with InputEventMouseMotion.relative we get the amount the mouse moved in the last frame
		rotate_object_local(Vector3(0,1,0),mouse_sens * -clickVec.x)
		get_node("FirstPersonCamera").rotate_object_local(Vector3(1,0,0),mouse_sens * -clickVec.y)
		transform = transform.orthonormalized()
			

func _physics_process(delta):
	
	velocity.y += gravity
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = jump_strength
	
	velocity = move_and_slide(velocity, Vector3(0,1,0))
	
	var change = Vector3(0,0,0)
	if Input.is_action_pressed("walk_left"):
		change.x -= 1
	if Input.is_action_pressed("walk_right"):
		change.x += 1
	if Input.is_action_pressed("walk_forward"):
		change.z -= 1
	if Input.is_action_pressed("walk_back"):
		change.z += 1
		
	change = change.normalized()
	translate_object_local(change*delta*movement_speed)

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -1.2, 1.2)
