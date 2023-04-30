extends Node

var deaths = 0
var minutes = 0
var seconds = 0
var ms = 0

func increase_death():
	deaths += 1
	get_node("/root/Spatial/GUI").update_death()

func reset_deaths():
	deaths = 0

func reset_timer():
	minutes = 0
	seconds = 0
	ms = 0
	
func _process(delta):
	ms += delta
	if ms >= 1:
		seconds += 1
		ms = 0
		if seconds >= 60:
			minutes += 1
			seconds = 0
	get_node("/root/Spatial/GUI").update_timer()
