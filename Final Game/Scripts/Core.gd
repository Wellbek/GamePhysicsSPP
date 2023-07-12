extends RigidBody

export var max_health = 100.0
onready var health = max_health

onready var gui = PlayerVariables.gui()
onready var core_bar = gui.get_node("TopBar/CoreBar")

var dead = false

onready var indicator_scene = load("res://Instances/GUI/DirectionalDamageIndicator.tscn")

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
	
	var indicator = indicator_scene.instance()
	
	gui.add_child(indicator)
	gui.move_child(indicator,0) # render it below everything else so that indicator texture doesnt block any buttons

	var player_transform = PlayerVariables.player().global_transform
	var player_forward = -player_transform.basis.z
	var direction = global_transform.origin - player_transform.origin
	
	var angle_rad = atan2(direction.x, direction.z) - atan2(player_forward.x, player_forward.z)
	if angle_rad < 0:
		angle_rad += 2 * PI

	indicator.set_rotation(-angle_rad)
	
	update_core_bar()
		
func die():
	dead = true
	PlayerVariables.gui().get_node("GameOverPanel").visible = true
	if debug: print("[" + name + "] died")
