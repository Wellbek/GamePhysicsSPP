extends RigidBody
	
var simulate = true # whether arrow is traveling or not
onready var my_root = get_parent()
export(NodePath) onready var ray = get_node(ray)
export(NodePath) onready var despawn_timer = get_node(despawn_timer)

var hit = false # true when ray collided => arrow will hit its target in the next frame

var ray_hit_point: Vector3

export var ray_amplifier = 3.0 # controls length of the ray

var damage = PlayerVariables.damage # NOTE: this will be set in Combat.gd when spawning the arrow

var col_impulse_magnitude = 0.2 # controls the magnitude of the linear_velocity that is transfered on collision with rigidbody 

export var debug = false
	
func _process(delta):
	if hit:
		# if last frame raycast has hit then correct position and disable raycast
		hit = false
		transform.origin -= ray.global_transform.origin - ray_hit_point # correct position
		ray.enabled = false; # disable raycast
		_on_Area_body_entered(ray.get_collider())
	
	if simulate:
		get_node("Spatial").look_at(global_transform.origin + linear_velocity, Vector3.UP)
		ray.cast_to.z = -abs(ray_amplifier * global_transform.basis.inverse().xform(linear_velocity).z * delta) # scale ray length relative to velocity
		if debug: LineDrawer.DrawRay(ray.global_transform.origin, ray_amplifier * linear_velocity * delta, Color.red)
		
		# destroy if out of render distance
		var distance_to_player = PlayerVariables.player.global_transform.origin.distance_to(global_transform.origin)
		if  distance_to_player > PlayerVariables.render_distance:
			queue_free() 
		
	if ray.is_colliding():
		hit = true
		ray_hit_point = ray.get_collision_point() # in world space

func _on_Area_body_entered(body):
	# sometimes body becomes null for some reason 
	if body == null: return
	
	# disable area collisionshape to not further collide with other objects
	get_node("Spatial/Area/CollisionShape").disabled = true
	
	if body.is_in_group("Enemy"):
		if body.has_method('take_damage'):
			body.take_damage(damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + body.get_script().get_path())
	
	# since we "can't" use rigidbody collision (can't rotate collision shape child on its own => look_at fails) we need to apply impulse manually on impact
	if body.has_method('apply_impulse'): 
		body.apply_impulse(ray_hit_point-body.global_transform.origin, linear_velocity * col_impulse_magnitude / body.mass)
	
	# stop physics
	linear_velocity = Vector3(0,0,0)
	sleeping = true
	simulate = false

	# stick to collision:
	var initial_transform = global_transform
	
	# 	unbind from parent
	my_root.remove_child(self)
	# 	set body as new parent
	body.add_child(self)
	my_root = body
	
	# 	keep global transform (position, rotation, scale)
	global_transform = initial_transform
	
	# start despawn timer
	despawn_timer.start()

func _on_DespawnTimer_timeout():
	queue_free()
