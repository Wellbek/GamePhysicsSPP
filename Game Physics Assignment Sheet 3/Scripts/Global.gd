extends Node

var deaths = 0
var minutes = 0
var seconds = 0
var ms = 0

func get_current_rot():
	var rot = get_node("/root/Spatial/Maze").get_global_transform().basis.y
	return rot

func increase_death():
	deaths += 1
	get_node("/root/Spatial/GUI").update_death()

func reset_deaths():
	deaths = 0

func reset_timer():
	minutes = 0
	seconds = 0
	ms = 0
	
func reset_scene(withGUI):
	if withGUI:
		reset_deaths()
		reset_timer()
	get_node("/root/Spatial/Maze").reset_rotation()
	get_node("/root/Spatial/Marble").respawn()
	
func _process(delta):
	ms += delta
	if ms >= 1:
		seconds += 1
		ms = 0
		if seconds >= 60:
			minutes += 1
			seconds = 0
	get_node("/root/Spatial/GUI").update_timer()
