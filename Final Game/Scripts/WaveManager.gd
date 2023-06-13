extends Node

onready var enemy = preload("res://Instances/Ogre.tscn")

onready var timer = get_node("Timer")

export(Array, NodePath) var spawnerNodePaths := []
onready var spawners: Array = loadNodes(spawnerNodePaths)

onready var upgrade_panel = PlayerVariables.gui.get_node("UpgradePanel")
onready var upgrade_label = PlayerVariables.gui.get_node("CanUpgradeLabel")
var can_upgrade = false

onready var wave_counter = PlayerVariables.gui.get_node("TopBar/WaveCounter/Background/Counter")
onready var kill_counter = PlayerVariables.gui.get_node("TopBar/KillCounter/Background/Counter")

var spawner_index = 0

var wave = 0

var normal_deviation = 0.3
var current_deviation = 0.3

var to_spawn = 0
var enemies_alive = 0

export var spawn_cd = 5

func _ready():
	start_wave()
	
func _process(delta):	
	if can_upgrade:
		if Input.is_action_just_pressed("upgrade_panel"):
			if upgrade_panel.visible: 
				upgrade_panel.hide()
				upgrade_label.show()
				get_tree().paused = false
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			else: 
				upgrade_panel.show()
				upgrade_label.hide()
				get_tree().paused = true
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func update_wave_counter(var _wave):
	wave_counter.text = str(_wave)
	
func loadNodes(nodePaths: Array) -> Array:
	var nodes := []
	for nodePath in nodePaths:
		var node := get_node(nodePath)
		if node != null:
			nodes.append(node)
	return nodes
	
func start_wave():
	can_upgrade = false
	wave += 1
	despawn_all_enemies()
	update_wave_counter(wave)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	upgrade_panel.hide()
	get_tree().paused = false
	if wave % 10 == 0:
		to_spawn = wave/2
		current_deviation = float(wave)/20
	else:
		to_spawn = wave
		current_deviation = normal_deviation
	timer.wait_time = spawn_cd
	timer.start()
	
func on_enemy_kill():
	enemies_alive -= 1
	PlayerVariables.kills += 1
	kill_counter.text = str(PlayerVariables.kills)
	if enemies_alive <= 0 and to_spawn <= 0:
		wave_complete()
		
func wave_complete():
	can_upgrade = true
	upgrade_panel.init_new_upgrades()
	upgrade_panel.show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	# reduce spawn cooldown every wave but always wait atleast 1 second
	spawn_cd -= 0.2
	if spawn_cd <= 1:
		spawn_cd = 1
		
func despawn_all_enemies():
	var enemies = get_tree().get_nodes_in_group("Enemy")
	
	for e in enemies:
		e.queue_free()
	
func _on_Timer_timeout():
	if to_spawn > 0:
		# just pick a random spawner
		spawner_index = randi() % spawners.size()
		
		spawners[spawner_index].spawn_enemy(enemy, current_deviation)
		enemies_alive += 1
		
		# alternate spawn locations
		#spawner_index += 1	
		#if spawner_index >= spawners.size():
		#	spawner_index = 0
		
		to_spawn -= 1
		if to_spawn == 0:
			timer.stop()
