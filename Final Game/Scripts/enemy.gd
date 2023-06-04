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

# if we want to have enemy attacking multiple things concurrently change to array
# and adjust functions accordingly
var attack_target = null

onready var nav = get_parent()
onready var target = nav.get_node("NavMesh/Core")
onready var attack_timer = get_node("AttackTimer")
onready var health_bar = get_node("HealthBar3D/Viewport/HealthBar2D")

export var debug = false

func _ready():
	health_bar.max_value = max_health
	health_bar.value = health
	
	attack_timer.wait_time = 1.0 / attack_speed

func _physics_process(delta):	
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
	if health_bar.value < health_bar.max_value and not health_bar.visible:
		health_bar.show()
		
func die():
	dead = true
	if debug: print("[" + name + "] died")
	queue_free() # exchange this later 

# ===================================================================
# Movement functions:
func move_to_target():	
	if transform.origin.distance_to(path[cur_path_index]) < threshold:
		path.remove(0)
	else:
		var direction = path[cur_path_index] - transform.origin
		velocity = direction.normalized() * speed
		move_and_slide(velocity, Vector3.UP)
		
# recompute path to target	
func get_target_path(target_pos):
	path = nav.get_simple_path(transform.origin, target_pos)

func _on_PathfindingTimer_timeout():
	get_target_path(target.transform.origin)
	
# ===================================================================
# Attack functions:
func _on_AttackRange_body_entered(body):
	if debug: print("["+ name + "] In range to attack: [" + body.name + "]")
	attack_target = body 
	attack_timer.start()


func _on_AttackRange_body_exited(body):
	if debug: print("["+ name + "] Out of range to attack: [" + body.name + "]")
	attack_target = null 
	attack_timer.stop()


func _on_AttackTimer_timeout():
	if attack_target != null:
		if attack_target.has_method('take_damage'):
			attack_target.take_damage(damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + attack_target.get_script().get_path())
