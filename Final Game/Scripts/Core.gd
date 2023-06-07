extends RigidBody

export var max_health = 100.0
onready var health = max_health

export(NodePath) onready var GUI = get_node(GUI)
onready var core_bar = GUI.get_node("CoreBar")

var dead = false

export var debug = false

func _ready():
	init_core_bar()
	
func init_core_bar():
	core_bar.max_value = max_health
	core_bar.value = health

func take_damage(var amount: float):
	if dead: return
	
	health -= amount
	
	if debug: print("[" + name + "] remaining health: " + str(health))
	
	if health <= 0:
		health = 0
		die()
	
	core_bar.value = health
		
func die():
	dead = true
	if debug: print("[" + name + "] died")
