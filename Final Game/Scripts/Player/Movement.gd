extends KinematicBody

export var accelaration_speed = 2.0
export var max_speed = 10.0
export var ground_friction = 0.85
export var air_friction = 0.95
export var jump_strength = 10.0
export var gravity = -.2
export var mouse_sens = 5.0
var clickVec = Vector2(0,0)
var velocity = Vector3(0,0,0)

export var number_of_extra_jumps = 0
var number_of_left_jumps = 0
var jumping = false

#This variable determines how long a jump is still possible after walking off a platform, so probably needs tweaking
export var coyote_max = 0.1
var coyote_timer = 0
var coyote_possible = false
var last_y_on_floor = 0

export var jump_buffer_time = 0.1
var buffer_cooldown = 0.2
var cooldown_timer = 0
var jump_timer = 0
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
	if is_on_floor():
		handle_wasd(delta, ground_friction, accelaration_speed)
	else:
		handle_wasd(delta, air_friction, accelaration_speed/6)
	
	#last parameter determines whether the player can move rigidbodies or view then as static bodies
	#the third and fourth parameters are the default values but i dont know how to keep them while also changing the last lol
	#first parameter is linear_velocity that is getting applied, second is the normal of the floor
	velocity = move_and_slide(velocity, Vector3(0,1,0), false, 4, 0.785398, true)

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -PI/2, 1.2)


#------------------------------ helper methods -----------------------------------
func handle_wasd(delta, velocity_damp, accelaration_speed):
	velocity.x *= velocity_damp
	velocity.z *= velocity_damp
	
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
	#translate_object_local(change*delta*movement_speed)
	change = change.rotated(Vector3(0,1,0), get_rotation().y) * accelaration_speed
	velocity.x += change.x
	velocity.z += change.z
	if velocity.x >= max_speed:
		velocity.x = max_speed
	if velocity.x <= -max_speed:
		velocity.x = -max_speed
	if velocity.z >= max_speed:
		velocity.z = max_speed
	if velocity.z <= -max_speed:
		velocity.z = -max_speed

func handle_jump(delta):
	
	update_buffer(delta)
	update_coyote(delta)
	
	velocity.y += gravity
	
	if is_on_floor():
		number_of_left_jumps = number_of_extra_jumps
	
	if Input.is_action_just_pressed("jump") && !is_on_floor() && number_of_left_jumps > 0:
		number_of_left_jumps-=1
		velocity.y = jump_strength
		cooldown_timer = buffer_cooldown
	
	if (Input.is_action_just_pressed("jump") || jump_buffered) && (is_on_floor() || coyote_possible):
		velocity.y = jump_strength
		cooldown_timer = buffer_cooldown
		number_of_left_jumps = number_of_extra_jumps
		if !is_on_floor():
			coyote_possible = false
	
	
func update_coyote(delta):
	if is_on_floor():
		coyote_timer = 0
		coyote_possible=true
		last_y_on_floor = transform.origin.y
	else:
		if last_y_on_floor > transform.origin.y && coyote_timer <= coyote_max && coyote_possible:
			coyote_timer += delta
		else:
			coyote_possible = false

func update_buffer(delta):
	if cooldown_timer >= 0:
		cooldown_timer -= delta
	
	if jump_timer <= jump_buffer_time:
		jump_timer += delta
	else:
		jump_buffered = false
	
	if Input.is_action_pressed("jump") && !is_on_floor() && cooldown_timer <= 0:
		jump_buffered = true
		jump_timer = 0
