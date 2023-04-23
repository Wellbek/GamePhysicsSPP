extends RigidBody

<<<<<<< HEAD
#Sphere
var center = Vector3(0,0,0)
var radius = 5.0

func _integrate_forces(state):
    var t = state.get_transform()
    var x = t.origin
    var velocity = state.get_linear_velocity()

    # Project the current position X onto the sphere
    var vector = x - center
    var closest_point = center + vector.normalized() * radius
	# Set new position
    t.origin = closest_point
    state.set_transform(t)

    # Adjust the velocity
    var tangent = vector.normalized()
    var velocity_normal = tangent * velocity.dot(tangent)
    velocity = velocity - velocity_normal
    state.set_linear_velocity(velocity)
=======
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
# Called when the node enters the scene tree for the first time.

var x0 = Vector3(0,0,0)
var r = 5


func _ready():
	pass # Replace with function body.

#func _integrate_forces(state):
#	var temp = state.get_transform().origin-x0
#	temp = temp.normalized()*r
#	state.set_transform(temp.origin)

func _integrate_forces(state):
    
    var x = state.get_transform().origin
    var vec = x - x0
    var norm_vec = vec.normalized()
    var proj_vec = norm_vec * r
    var x_proj = proj_vec + x0
    
    #state.set_transform(Transform(X_proj, state.get_transform().basis))
    state.set_transform(state.get_transform().translated(-state.get_transform().origin))
    state.set_transform(state.get_transform().translated(x_proj))
>>>>>>> efe4fb982bda63d641905a3b3bbab852a6b75b03
