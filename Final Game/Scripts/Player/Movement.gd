extends KinematicBody

export var accelaration_speed = 2.0
export var accelaration_speed_in_air = 0.4
export var max_speed = 10.0
export var ground_friction = 0.85
export var air_friction = 0.95
export var jump_strength = 10.0
export var gravity = -.2
var cur_gravity = gravity
export var mouse_sens = 3.0
export var push_strength = 5.0
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

# Camera
onready var main_camera = get_node("FirstPersonCamera")
onready var weapon_camera = get_node("CanvasLayer/ViewportContainer/Viewport/WeaponCamera")

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
	# Camera
	weapon_camera.global_transform = main_camera.global_transform
	
	handle_jump(delta)
	if is_on_floor():
		handle_wasd(delta, ground_friction, accelaration_speed)
	else:
		handle_wasd(delta, air_friction, accelaration_speed_in_air)
		
	
	#push enemies:
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision == null || collision.collider == null: continue #Sometims this is null, idk if this fixed it
		var normal = collision.normal
		if normal.x*normal.x < 0.1 && normal.z*normal.z < 0.1: #enables the player to stand on top of bodies without pushing them weirdly
			normal = Vector3(0,0,0)
		if collision.collider.is_in_group("Enemy") && collision.collider.is_in_group("Pushable"):
			collision.collider.apply_central_impulse(-normal * push_strength*2)
		elif collision.collider.is_in_group("Pushable"):
			collision.collider.apply_central_impulse(-normal * push_strength)
	
	#last parameter determines whether the player can move rigidbodies or view then as static bodies
	#the third and fourth parameters are the default values but i dont know how to keep them while also changing the last lol
	#first parameter is linear_velocity that is getting applied, second is the normal of the floor
	velocity = move_and_slide(velocity, Vector3(0,1,0), false, 4, 0.785398, false)
	

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -PI/2, PI/2)


#------------------------------ helper methods -----------------------------------
func handle_wasd(_delta, velocity_damp, accelaration_speed):
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
	change.x += velocity.x
	change.z += velocity.z
	if change.length() > max_speed:
		change = change.normalized() * max_speed
	
	velocity.x = change.x
	velocity.z = change.z

func handle_jump(delta):
	
	update_buffer(delta)
	update_coyote(delta)
	
	velocity.y += cur_gravity
	
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
