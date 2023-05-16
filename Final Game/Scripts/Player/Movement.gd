extends Spatial

export var mouse_sens = 5.0
var clickVec = Vector2(0,0)

var pending_rotation = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) #locks mouse to the center of screen
	Input.set_use_accumulated_input(false) #makes Input events emit as often as possible => smoother rotation
	
func _input(event):
	if event is InputEventMouseMotion:
		clickVec = event.relative/10 # with InputEventMouseMotion.relative we get the amount the mouse moved in the last frame
		pending_rotation = true
			

func _physics_process(delta):
	# This isnt possible anymore because it would override the MOUSE_MODE_CAPTURED
	#if Input.is_action_just_pressed("show_mouse"):
	#	if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
	#		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	#	else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Mouse Rotation:
	if pending_rotation:
		rotate_object_local(Vector3(0,1,0),mouse_sens * delta * -clickVec.x)
		get_node("FirstPersonCamera").rotate_object_local(Vector3(1,0,0),mouse_sens * delta * -clickVec.y)
		pending_rotation = false

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -1.2, 1.2)
