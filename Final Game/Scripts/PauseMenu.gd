extends Panel


onready var upgrade_panel = PlayerVariables.gui().get_node("UpgradePanel")
onready var game_over_panel = PlayerVariables.gui().get_node("GameOverPanel")

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel") && !upgrade_panel.visible && !game_over_panel.visible:
		if visible:
			unpause()
		else:
			pause()

func pause():
	show()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func unpause():
	hide()
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _on_UnpauseButton_button_up():
	unpause()

func _on_MouseSensSlider_value_changed(value):
	PlayerVariables.player().mouse_sens = value
