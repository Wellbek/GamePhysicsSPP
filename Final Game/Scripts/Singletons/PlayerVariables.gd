extends Node

# reference to the player object
var player

# NOTE: might needs to be adjusted when changing scenes as game mechanic 
#		Idea: have a function that sets player variable and is called on each scene start
func _ready():
	player = get_tree().root.get_node("Spatial/Player")
