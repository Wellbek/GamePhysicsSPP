extends Panel

onready var wm = get_tree().root.get_node("Spatial/WaveManager")

onready var buttons = [get_node("Button1"), get_node("Button2"), get_node("Button3")]

onready var player = PlayerVariables.player()

onready var upgrade_label = get_parent().get_node("CanUpgradeLabel")

# Add upgrades here by appending to the list and extending the match statement in apply_upgrade
enum UpgradeType{
	NONE,
	CORE_HEAL,
	JUMP_STRENGTH_UP,
	MAX_SPEED_UP,
	DAMAGE_UP,
	EXTRA_JUMP,
	ATTACK_SPEED_UP
	CORE_MAX_HEALTH_UP,
	SLOWER_ENEMY_SPAWN,
	SHOOT_RANGE_UP,
	EXTRA_ARROW,
	MULTI_ARROW_SPAN_DOWN
}

var current_upgrades = [UpgradeType.NONE, UpgradeType.NONE, UpgradeType.NONE]

func enum_to_string(var enum_value):
	var enum_str = str(enum_value)
	enum_str = enum_str.replace("_", " ")
	enum_str = enum_str.to_lower()
	return enum_str.capitalize()

func init_new_upgrades():	
	var available_upgrades = UpgradeType.keys()
	available_upgrades.remove(UpgradeType.CORE_HEAL)
	available_upgrades.remove(UpgradeType.NONE)
	
	for i in 3:
		var available_index = randi() % available_upgrades.size()
		var new_upgrade = available_upgrades[available_index]
		current_upgrades[i] = new_upgrade
		available_upgrades.remove(available_index) # remove from available list to not choose again (no duplicates)
		buttons[i].text = enum_to_string(new_upgrade)

func _on_Button1_button_up():	
	apply_upgrade(UpgradeType[current_upgrades[0]])
	# maybe decrease default_spawn_cd the higher wave we are?
	wm.start_wave()
	
func _on_Button2_button_up():	
	apply_upgrade(UpgradeType[current_upgrades[1]])
	wm.start_wave()
	
func _on_Button3_button_up():	
	apply_upgrade(UpgradeType[current_upgrades[2]])
	wm.start_wave()
	
func _on_Button4_button_up():
	apply_upgrade(UpgradeType.CORE_HEAL)
	wm.start_wave()
	
func apply_upgrade(var upgrade: int):
	match upgrade:
		UpgradeType.NONE:
			pass
			
		UpgradeType.CORE_HEAL:
			PlayerVariables.core().health += 0.3 * PlayerVariables.core().max_health
			if PlayerVariables.core().health > PlayerVariables.core().max_health:
				PlayerVariables.core().health = PlayerVariables.core().max_health
			PlayerVariables.core().update_core_bar()
			
		UpgradeType.JUMP_STRENGTH_UP:
			player.jump_strength *= 1.2
			
		UpgradeType.MAX_SPEED_UP:
			player.accelaration_speed *= 1.1
			player.accelaration_speed_in_air *= 1.1
			player.max_speed *= 1.4
			
		UpgradeType.DAMAGE_UP:
			PlayerVariables.bow_combat().damage *= 1.3
			
		UpgradeType.EXTRA_JUMP:
			player.number_of_extra_jumps += 1
			
		UpgradeType.ATTACK_SPEED_UP:
			PlayerVariables.bow_combat().increase_attack_speed(1.15)
			
		UpgradeType.CORE_MAX_HEALTH_UP:
			var amount = PlayerVariables.core().max_health * .2
			PlayerVariables.core().max_health += amount
			PlayerVariables.core().health += amount
			PlayerVariables.core().update_core_bar()
			
		UpgradeType.SLOWER_ENEMY_SPAWN:
			wm.spawn_cd += 1 # 1 second longer cooldown
			
		UpgradeType.SHOOT_RANGE_UP:
			PlayerVariables.bow_combat().shoot_range *= 1.2
			
		UpgradeType.EXTRA_ARROW:
			PlayerVariables.bow_combat().number_of_arrows += 1
			
		UpgradeType.MULTI_ARROW_SPAN_DOWN:
			PlayerVariables.bow_combat().shoot_span /= 1.3

func _on_closePanelButton_button_up():
	PlayerVariables.gui().closeAllPanels()
	upgrade_label.show()
