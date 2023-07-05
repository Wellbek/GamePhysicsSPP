extends RigidBody

var on_cooldown = false

func hit():
	var material = SpatialMaterial.new();
	material.albedo_color = Color(0.5, 1, 0.5, 1)
	get_node("TargetMesh").material_override = material
	
	var timer = get_node("Timer")
	
	on_cooldown = true
	timer.start(15)
	
func _on_Timer_timeout():
	#var material = get_node("TargetMesh").get_surface_material(0);
	#material.albedo_color = Color(1, 1, 1)
	#get_node("TargetMesh").set_surface_material(0, material)
	
	get_node("TargetMesh").material_override = null
	
	on_cooldown = false
