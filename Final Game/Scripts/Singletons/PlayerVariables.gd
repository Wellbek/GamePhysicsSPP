extends Node

# reference to the player object
# NOTE: might needs to be adjusted when changing scenes as game mechanic 
#		Idea: have a function that sets player variable and is called on each scene start
onready var player = get_tree().root.get_node("Spatial/Player")
onready var player_combat = player.get_node(player.weapon_camera).get_node("Bow")

var render_distance = 50
var damage = 12

var kills = 0

#for mainscene
onready var core = get_tree().root.get_node("Spatial/Terrain/Core")
#for Prototype scene
#onready var core = get_tree().root.get_node("Spatial/PathfindingTest/Navigation/NavMesh/Core") # NOTE: temporary solution while we just have one core (cba writing new script just for this)

onready var wave_manager = get_tree().root.get_node("Spatial/WaveManager") # idk not good solution but works for now
onready var gui = get_tree().root.get_node("Spatial/GUI")

func _ready():
	randomize()
