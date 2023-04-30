extends RigidBody

export var respawnLocation = Vector3(0,0,0)

func _process(delta):
	if transform.origin.y < -5.0:
		Global.increase_death()
		transform.origin = respawnLocation
