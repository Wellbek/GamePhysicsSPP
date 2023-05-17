extends KinematicBody

export var movement_speed = 10.0
export var jump_strength = 10.0
export var gravity = -.2
export var mouse_sens = 5.0
var clickVec = Vector2(0,0)
var velocity = Vector3(0,0,0)

var jump_timer = 0
export var jump_buffer_time = 0.1
var can_press_jump = true
var jump_buffered = false

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
	
	handle_jump(delta)
	
	handle_wasd(delta)

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -PI/2, 1.2)


#------------------------------ helper methods -----------------------------------
func handle_wasd(delta):
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

func handle_jump(delta):
	
	if jump_timer <= jump_buffer_time:
		jump_timer += delta
	else:
		jump_buffered = false
	
	if Input.is_action_pressed("jump") && !is_on_floor():
		jump_buffered = true
		jump_timer = 0
	
	velocity.y += gravity
	if (Input.is_action_just_pressed("jump") || jump_buffered) && is_on_floor():
		velocity.y = jump_strength
	
	#last parameter determines whether the player can move rigidbodies or view then as static bodies
	#the third and fourth parameters are the default values but i dont know how to keep them while also changing the last lol
	#first parameter is linear_velocity that is getting applied, second is the normal of the floor
	velocity = move_and_slide(velocity, Vector3(0,1,0), false, 4, 0.785398, false)
