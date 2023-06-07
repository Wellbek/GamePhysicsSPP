extends Panel

onready var wm = get_tree().root.get_node("Spatial/WaveManager")

func _on_Button_button_up():	
	# maybe decrease default_spawn_cd the higher wave we are?
	wm.start_wave(wm.wave, wm.default_spawn_cd)
