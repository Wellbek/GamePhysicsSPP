extends RigidBody

var on_cooldown = false

func hit():
	var material = get_node("MeshInstance").get_surface_material(0);
	material.albedo_color = Color(1, 0, 0)
	get_node("MeshInstance").set_surface_material(0, material)
	
	var timer = get_node("Timer")
	
	on_cooldown = true
	timer.start(15)
	
func _on_Timer_timeout():
	var material = get_node("MeshInstance").get_surface_material(0);
	material.albedo_color = Color(1, 1, 1)
	get_node("MeshInstance").set_surface_material(0, material)
	
	on_cooldown = false
