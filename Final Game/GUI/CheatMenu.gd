extends Panel

onready var upgrade_panel = PlayerVariables.gui().get_node("UpgradePanel")
onready var wave_manager = PlayerVariables.wave_manager()

func _process(_delta):
	if Input.is_action_just_pressed("cheats_panel") && PlayerVariables.cheats_enabled && !PlayerVariables.inMenu:
		pause()
		
func pause():
	PlayerVariables.inMenu = true
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func unpause():
	PlayerVariables.inMenu = false
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_Button_button_up(upgrade):
	upgrade_panel.apply_upgrade(upgrade)

func _on_NextWave_button_up():
	wave_manager.wave_complete(false)
	unpause()

func _on_close_button_up():
	unpause()
