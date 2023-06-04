extends RigidBody
	
var simulate = true # whether arrow is traveling or not
onready var my_root = get_parent().get_parent()
onready var ray = get_node("Spatial/RayCast")
onready var despawn_timer = get_parent().get_node("DespawnTimer")

var hit = false

var ray_hit_point: Vector3

export var ray_amplifier = 3.0 # controls length of the ray

export var debug = false
	
func _process(delta):
	if hit:
		# if last frame raycast has hit then correct position and disable raycast
		hit = false
		get_parent().transform.origin -= ray.global_transform.origin - ray_hit_point # correct position
		ray.enabled = false; # disable raycast
		_on_Area_body_entered(ray.get_collider())
	
	if simulate:
		get_node("Spatial").look_at(global_transform.origin + linear_velocity, Vector3.UP)
		ray.cast_to = ray_amplifier * global_transform.basis.inverse().xform(linear_velocity) * delta # set raycast length to global linear velocity times timestep
		if debug: LineDrawer.DrawRay(ray.global_transform.origin, ray_amplifier * linear_velocity * delta, Color.red)
		
		# destroy if out of render distance
		var distance_to_player = PlayerVariables.player.global_transform.origin.distance_to(global_transform.origin)
		if  distance_to_player > PlayerVariables.render_distance:
			get_parent().queue_free() 
		
	if ray.is_colliding():
		hit = true
		ray_hit_point = ray.get_collision_point() # in world space

func _on_Area_body_entered(body):
	# disable area collisionshape to not further collide with other objects
	get_node("Spatial/Area/CollisionShape").disabled = true
	
	# stop physics
	linear_velocity = Vector3(0,0,0)
	sleeping = true
	simulate = false

	# stick to collision:
	var initial_transform = global_transform
	
	# 	unbind from parent
	my_root.remove_child(get_parent())
	# 	set body as new parent
	body.add_child(get_parent())
	my_root = body
	
	# 	keep global transform (position, rotation, scale)
	global_transform = initial_transform
	
	if body.is_in_group("Enemy"):
		if body.has_method('take_damage'):
			body.take_damage(PlayerVariables.damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + body.get_script().get_path())
	
	# start despawn timer
	despawn_timer.start()

func _on_DespawnTimer_timeout():
	get_parent().queue_free()
