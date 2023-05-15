extends RigidBody

var child = null

func _ready():
	child = get_child(0);

func _process(delta):
	# works kinda. however, the max/min rot we can get from start is like +/-25 (and just doesnt rlly look right in game)
	var vec = Vector2(max(-global_transform.basis.inverse().xform(linear_velocity).z, 0),  linear_velocity.y)
	var rot = int(rad2deg(vec.angle()))
	if child.rotation.x != rot:
		child.rotation_degrees.x = rot
