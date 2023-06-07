extends KinematicBody

export var speed = 3.0
export var attack_speed = 1.0
export var damage = 5

export var max_health = 100.0
var health = max_health
var dead = false

var path = []
var cur_path_index = 0
var velocity = Vector3.ZERO
var threshold = .1 # distance threshold when considered at target location

export(NodePath) onready var nav_mesh_collider = get_node(nav_mesh_collider)

# if we want to have enemy attacking multiple things concurrently change to array
# and adjust functions accordingly
var attack_target = null

onready var nav = get_parent()
onready var target = nav.get_node("NavMesh/Core")
onready var attack_timer = get_node("AttackTimer")
onready var despawn_timer = get_node("DespawnTimer")
onready var health_bar = get_node("HealthBar3D/Viewport/HealthBar2D")

export var debug = false

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health
	
	attack_timer.wait_time = 1.0 / attack_speed

func _physics_process(delta):	
	if dead: return
	
	# Movement:
	if path.size() > 0:
		move_to_target()

# ===================================================================
# Damageable functions:
func take_damage(var amount: float):
	if dead: return
	
	health -= amount
	
	if debug: print("[" + name + "] remaining health: " + str(health))
	
	if health <= 0:
		health = 0
		die()
	
	health_bar.value = health
	if health_bar.value < health_bar.max_value and not health_bar.visible and not dead:
		health_bar.show()
		
func die():
	dead = true
	if debug: print("[" + name + "] died")
	
	if nav_mesh_collider: nav_mesh_collider.disabled = true
	
	PlayerVariables.wave_manager.on_enemy_kill()
	
	health_bar.hide()
	
	# set all rb children rigid => ~ ragdoll
	var model = get_node("Model/Spatial")
	for i in range(model.get_child_count()):
		var child = model.get_child(i)
		if is_instance_valid(child) and child is RigidBody:
			var rb = child as RigidBody
			# Do something with the rigidbody
			if rb.has_method("change_mode"):
				rb.change_mode(RigidBody.MODE_RIGID)
				
	# start despawn timer
	despawn_timer.start()

# ===================================================================
# Movement functions:
func move_to_target():	
	if dead: return
	
	if transform.origin.distance_to(path[cur_path_index]) < threshold:
		path.remove(0)
	else:
		var direction = path[cur_path_index] - transform.origin
		velocity = direction.normalized() * speed
		move_and_slide(velocity, Vector3.UP)
		
# recompute path to target	
func get_target_path(target_pos):
	if dead: return
	
	path = nav.get_simple_path(transform.origin, target_pos)

func _on_PathfindingTimer_timeout():
	if dead: return
	
	get_target_path(target.transform.origin)
	
# ===================================================================
# Attack functions:
func _on_AttackRange_body_entered(body):
	if dead: return
	
	if debug: print("["+ name + "] In range to attack: [" + body.name + "]")
	attack_target = body 
	attack_timer.start()


func _on_AttackRange_body_exited(body):
	if dead: return
	
	if debug: print("["+ name + "] Out of range to attack: [" + body.name + "]")
	attack_target = null 
	attack_timer.stop()


func _on_AttackTimer_timeout():
	if dead: return
	
	if attack_target != null:
		if attack_target.has_method('take_damage'):
			attack_target.take_damage(damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + attack_target.get_script().get_path())

func _on_DespawnTimer_timeout():
	queue_free()
