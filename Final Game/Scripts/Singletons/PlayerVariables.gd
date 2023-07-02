extends Node

var render_distance = 50

var kills = 0

var cheats_enabled = true

var inMenu = false

#for mainscene
#var core
#for Prototype scene
#onready var core = get_tree().root.get_node("Spatial/PathfindingTest/Navigation/NavMesh/Core") # NOTE: temporary solution while we just have one core (cba writing new script just for this)


func _ready():
	randomize()
	
func player():
	return get_tree().root.get_node("Spatial/Player")
	
func bow_combat():
	var player = get_tree().root.get_node("Spatial/Player")
	return player.weapon_camera.get_node("Bow")
	
func knife_combat():
	var player = get_tree().root.get_node("Spatial/Player")
	return player.weapon_camera.get_node("Knife")

func core():
	return get_tree().root.get_node("Spatial/Terrain/Core")

func wave_manager():
	return get_tree().root.get_node("Spatial/WaveManager")

func gui():
	return get_tree().root.get_node("Spatial/GUI")

func reset_variables():
	kills = 0
	inMenu = false
