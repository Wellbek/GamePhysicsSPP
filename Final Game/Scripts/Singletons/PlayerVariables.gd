extends Node

# reference to the player object
# NOTE: might needs to be adjusted when changing scenes as game mechanic 
#		Idea: have a function that sets player variable and is called on each scene start
onready var player = get_tree().root.get_node("Spatial/Player")
var render_distance = 50
var damage = 25
