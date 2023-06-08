extends RigidBody

export var max_health = 100.0
onready var health = max_health

onready var core_bar = PlayerVariables.gui.get_node("TopBar/CoreBar")

var dead = false

export var debug = false

func _ready():
	update_core_bar()
	
func update_core_bar():
	core_bar.max_value = max_health
	core_bar.value = health

func take_damage(var amount: float):
	if dead: return
	
	health -= amount
	
	if debug: print("[" + name + "] remaining health: " + str(health))
	
	if health <= 0:
		health = 0
		die()
	
	update_core_bar()
		
func die():
	dead = true
	if debug: print("[" + name + "] died")
