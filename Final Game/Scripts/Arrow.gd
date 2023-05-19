extends RigidBody
	
var simulate = true
var my_root = null
	
func _ready():
	my_root = get_parent().get_parent()
	
func _process(delta):
	if simulate:
		get_node("Spatial").look_at(global_transform.origin + linear_velocity, Vector3.UP)

func _on_Area_body_entered(body):
	# disable area collisionshape to not further collide with other objects
	get_node("Spatial/Area/CollisionShape").disabled = true
	
	# stop physics
	linear_velocity = Vector3(0,0,0)
	sleeping = true
	simulate = false

	# stick to collision:
	var initial_transform = global_transform
	
	# 	unbind from parent
	my_root.remove_child(get_parent())
	# 	set body as new parent
	body.add_child(get_parent())
	my_root = body
	
	# 	keep global transform (position, rotation, scale)
	global_transform = initial_transform
