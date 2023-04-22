extends RigidBody

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