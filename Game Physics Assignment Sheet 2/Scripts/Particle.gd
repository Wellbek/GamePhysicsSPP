extends Spatial

const gravity = Vector3(0,-0.98,0)

export var bounce = 0.8
export var velocity = Vector3(0,0,0)
export var mass = 1.0

var b = 10.25 # e)

const pRadius = 0.2
	
func _physics_process(delta):
	velocity = velocity + delta / mass * gravity
	
	if transform.origin.y <= pRadius:
		transform.origin.y = pRadius
		velocity.y = - bounce * velocity.y
		
	# e) (Optional) constraints to prevent particles from penetrating walls
	for axis in ['x', 'z']:
		if transform.origin[axis] <= -b + pRadius:
			transform.origin[axis] = -b + pRadius
			velocity[axis] = - bounce * velocity[axis]
		elif transform.origin[axis] >= b - pRadius:
			transform.origin[axis] = b - pRadius
			velocity[axis] = - bounce * velocity[axis]
		
	transform.origin = transform.origin + delta*velocity
