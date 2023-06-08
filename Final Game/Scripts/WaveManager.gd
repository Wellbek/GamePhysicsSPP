extends Node

onready var enemy = preload("res://Instances/Ogre.tscn")

onready var timer = get_node("Timer")

export(Array, NodePath) var spawnerNodePaths := []
onready var spawners: Array = loadNodes(spawnerNodePaths)

onready var upgrade_panel = PlayerVariables.gui.get_node("UpgradePanel")

onready var wave_counter = PlayerVariables.gui.get_node("TopBar/WaveCounter/Background/Counter")
onready var kill_counter = PlayerVariables.gui.get_node("TopBar/KillCounter/Background/Counter")

var spawner_index = 0

var wave = 1

var to_spawn = 0
var enemies_alive = 0

export var spawn_cd = 5

func _ready():
	start_wave(wave)
	
func update_wave_counter(var _wave):
	wave_counter.text = str(_wave)
	
func loadNodes(nodePaths: Array) -> Array:
	var nodes := []
	for nodePath in nodePaths:
		var node := get_node(nodePath)
		if node != null:
			nodes.append(node)
	return nodes
	
func start_wave(var _amount):
	update_wave_counter(wave)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	upgrade_panel.hide()
	to_spawn = _amount
	timer.wait_time = spawn_cd
	timer.start()
	
func on_enemy_kill():
	enemies_alive -= 1
	PlayerVariables.kills += 1
	kill_counter.text = str(PlayerVariables.kills)
	if enemies_alive <= 0 and to_spawn <= 0:
		wave_complete()
		
func wave_complete():
	wave += 1
	upgrade_panel.init_new_upgrades()
	upgrade_panel.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# reduce spawn cooldown every wave but always wait atleast 1 second
	spawn_cd -= 0.15
	if spawn_cd <= 1:
		spawn_cd = 1
	
func _on_Timer_timeout():
	if to_spawn > 0:
		spawners[spawner_index].spawn_enemy(enemy)
		enemies_alive += 1
		
		# alternate spawn locations
		spawner_index += 1	
		if spawner_index >= spawners.size():
			spawner_index = 0
		
		to_spawn -= 1
		if to_spawn == 0:
			timer.stop()
