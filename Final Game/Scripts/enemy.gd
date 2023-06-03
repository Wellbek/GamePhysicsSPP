extends KinematicBody

export var speed = 3

var path = []
var cur_path_index = 0
var velocity = Vector3.ZERO
var threshold = .1 # distance threshold when considered at target location

onready var nav = get_parent()
onready var target = nav.get_node("NavMesh/Core")

func _physics_process(delta):	
	if path.size() > 0:
		move_to_target()
		
func move_to_target():	
	if transform.origin.distance_to(path[cur_path_index]) < threshold:
		path.remove(0)
	else:
		var direction = path[cur_path_index] - transform.origin
		velocity = direction.normalized() * speed
		move_and_slide(velocity, Vector3.UP)
		
func get_target_path(target_pos):
	path = nav.get_simple_path(transform.origin, target_pos)
	
func _on_Timer_timeout():
	get_target_path(target.transform.origin)
