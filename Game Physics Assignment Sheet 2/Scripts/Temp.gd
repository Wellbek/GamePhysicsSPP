extends Spatial

const gravity = Vector3(0,-9.8,0)
export var velocity = Vector3(0,0,0)

export var mass = 1.0

const pRadius = 0.2

export var restitution = 0.8
	
func _physics_process(delta):
	velocity = velocity + delta / mass * gravity
	
	if transform.origin.y <= pRadius:
		transform.origin.y = pRadius
		velocity.y = - restitution * velocity.y
		
	transform.origin = transform.origin + delta*velocity


