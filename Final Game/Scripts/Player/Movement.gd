extends Spatial

export var mouse_sens = 5.0
export var clickOrigin = Vector2(0,0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) # hide mouse by default

func _physics_process(delta):
	if Input.is_action_just_pressed("show_mouse"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_HIDDEN:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

	# Mouse Rotation:
	var clickVec = get_viewport().get_mouse_position() - clickOrigin
	clickOrigin = get_viewport().get_mouse_position()
	clickVec = clickVec / 10
	rotate_object_local(Vector3(0,1,0),mouse_sens * delta * -clickVec.x)
	get_node("FirstPersonCamera").rotate_object_local(Vector3(1,0,0),mouse_sens * delta * -clickVec.y)

	# limit camera rotation along x (so we can only look up/down a certain amount)
	var myRot = get_node("FirstPersonCamera").get_rotation()
	get_node("FirstPersonCamera").rotation.x = clamp(myRot.x, -1.2, 1.2)
