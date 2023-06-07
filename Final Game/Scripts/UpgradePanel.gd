extends Panel

onready var wm = get_tree().root.get_node("Spatial/WaveManager")

onready var buttons = [get_node("Button1"), get_node("Button2"), get_node("Button3")]

onready var player = PlayerVariables.player

# Add upgrades here by appending to the list and extending the match statement in apply_upgrade
var available_upgrades = ["Jump strength up", "Max speed up", "Airborne Movement up", "Damage up", "Extra Jump"]

var current_upgrades = [0,0,0]

func init_new_upgrades():
	for i in 3:
		var new_upgrade = randi() % available_upgrades.size()
		current_upgrades[i] = new_upgrade
		buttons[i].text = available_upgrades[new_upgrade]

func _on_Button1_button_up():	
	apply_upgrade(current_upgrades[0])
	# maybe decrease default_spawn_cd the higher wave we are?
	wm.start_wave(wm.wave, wm.default_spawn_cd)
	
func _on_Button2_button_up():	
	apply_upgrade(current_upgrades[1])
	wm.start_wave(wm.wave, wm.default_spawn_cd)
	
func _on_Button3_button_up():	
	apply_upgrade(current_upgrades[2])
	wm.start_wave(wm.wave, wm.default_spawn_cd)
	
func apply_upgrade(var upgrade: int):
	match upgrade:
		0:
			player.jump_strength *= 1.1
		1:
			player.max_speed *= 2
		2:
			player.accelaration_speed_in_air *= 1.5 
		3:
			PlayerVariables.damage += 3
		4:
			player.number_of_extra_jumps += 1
