extends RigidBody

var arrowkeySpeed = 0.7
export var mouseSpeed = 5.0
export var clickOrigin = Vector2(0,0)
export var maxRotPerFrame = .01 # avoids tunneling when rotating rapidly (the lower the framerate the higher the variables value should be)

export var pathToNewScene = "res://Scenes/MarbleMaze.tscn"

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

	rotate_object_local(Vector3(0,0,1),clamp(arrowkeySpeed * delta * rotChange.z, -maxRotPerFrame, maxRotPerFrame))
	rotate_object_local(Vector3(1,0,0),clamp(arrowkeySpeed * delta * rotChange.x, -maxRotPerFrame, maxRotPerFrame))
	# ======================================
	# Mouse Rotation:
	if Input.is_action_just_pressed("unlock_camera"):
		clickOrigin = get_viewport().get_mouse_position()
	
	if Input.is_action_pressed("unlock_camera"):
		var clickVec = get_viewport().get_mouse_position() - clickOrigin
		clickOrigin = get_viewport().get_mouse_position()
		clickVec = clickVec
		rotate_object_local(Vector3(0,0,1),clamp(mouseSpeed * delta * -clickVec.x, -maxRotPerFrame, maxRotPerFrame))
		rotate_object_local(Vector3(1,0,0),clamp(mouseSpeed * delta * clickVec.y, -maxRotPerFrame, maxRotPerFrame))
	# ======================================
	
	#limit rotation along x,z and lock along y
	var myRot = get_rotation()
	rotation = Vector3(clamp(myRot.x, -.2, .2), 0, clamp(myRot.z, -.2, .2))


func _on_GoalZone_body_entered(body):
	if body.name == "Marble":
		get_tree().change_scene(pathToNewScene)
