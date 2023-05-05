extends RigidBody

export var respawnLocation = Vector3(0,0,0)

func _process(delta):
	if transform.origin.y < -5.0:
		Global.increase_death()
		Global.reset_scene(false)
		
func respawn():
	transform.origin = respawnLocation
	set_linear_velocity(Vector3(0,0,0))
	set_angular_velocity(Vector3(0,0,0))
