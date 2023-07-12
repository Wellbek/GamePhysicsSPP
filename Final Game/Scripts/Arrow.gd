extends RigidBody
	
var simulate = true # whether arrow is traveling or not
onready var my_root = get_parent()

# NOTE: cant use "export(NodePath) onready var ray = get_node(ray)" because this will cause erros
#		this is due to us deleting the arrow dynamically but the path will still exist and then idk weird error
onready var ray = get_node("Spatial/RayCast") 

var hit = false # true when ray collided => arrow will hit its target in the next frame

var ray_hit_point: Vector3

export var ray_amplifier = 3.0 # controls length of the ray

var damage = 1 # NOTE: this will be set in Combat.gd when spawning the arrow

var col_impulse_magnitude = 0.2 # controls the magnitude of the linear_velocity that is transfered on collision with rigidbody 

export var debug = false
	
func _process(delta):
	if hit:
		# if last frame raycast has hit then correct position and disable raycast
		hit = false
		simulate = false
		transform.origin -= ray.global_transform.origin - ray_hit_point # correct position		
		_on_Area_body_entered(ray.get_collider())
	
	if simulate:
		if (linear_velocity.length() != 0): get_node("Spatial").look_at(global_transform.origin + linear_velocity, Vector3.UP)
		ray.cast_to.z = -abs(ray_amplifier * global_transform.basis.inverse().xform(linear_velocity).z * delta) # scale ray length relative to velocity
		if debug: LineDrawer.DrawRay(ray.global_transform.origin, ray_amplifier * linear_velocity * delta, Color.red)
		
		# destroy if out of render distance
		var distance_to_player = PlayerVariables.player().global_transform.origin.distance_to(global_transform.origin)
		if  distance_to_player > PlayerVariables.render_distance:
			queue_free() 
		
	if ray.is_colliding():
		hit = true
		# prevent further collision
		ray.enabled = false; 
		get_node("Spatial/Area").monitoring = false
		
		ray_hit_point = ray.get_collision_point() # in world space

func _on_Area_body_entered(body):
	# sometimes body becomes null for some reason 
	if body == null || sleeping: return
	
	if body.is_in_group("Enemy"):
		if body.has_method('take_damage'):
			body.take_damage(damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + body.get_script().get_path())
	
	elif body.is_in_group("AimTarget"):
		if not body.on_cooldown:		
			var container = PlayerVariables.gui().get_node("StatBoostBox")	
			container.add_child(load("res://Instances/GUI/StatBoostPanel.tscn").instance())
			body.hit()
		
	# since we "can't" use rigidbody collision (can't rotate collision shape child on its own => look_at fails) we need to apply impulse manually on impact
	if body.has_method('apply_impulse'): 
		body.apply_impulse(ray_hit_point-body.global_transform.origin, linear_velocity * col_impulse_magnitude / body.mass)	
		
	
	# stop physics
	linear_velocity = Vector3(0,0,0)
	sleeping = true
	simulate = false
	
	# stick to collision:
	var mesh = get_node("Spatial/ArrowMesh")
	#if mesh == null: queue_free() # highly unlikely but very rarely two collisions "at once" i.e. mesh can already be "gone"
	var initial_transform = mesh.global_transform
	
	# unbind from parent
	get_node("Spatial").remove_child(mesh)
	# set body as new parent
	body.add_child(mesh)
	my_root = body
	
	# keep global transform (position, rotation, scale)
	mesh.global_transform = initial_transform
	
	mesh.start_despawn()
		
	queue_free()
