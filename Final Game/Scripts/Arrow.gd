extends RigidBody

var child = null

func _ready():
	child = get_child(0);

func _process(delta):
	child.look_at(global_transform.origin + linear_velocity, Vector3.UP)
