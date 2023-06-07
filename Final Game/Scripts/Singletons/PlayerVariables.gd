extends Node

# reference to the player object
# NOTE: might needs to be adjusted when changing scenes as game mechanic 
#		Idea: have a function that sets player variable and is called on each scene start
onready var player = get_tree().root.get_node("Spatial/Player")
var render_distance = 50
var damage = 15

onready var wave_manager = get_tree().root.get_node("Spatial/WaveManager") # idk not good solution but works for now
onready var gui = get_tree().root.get_node("Spatial/GUI")
