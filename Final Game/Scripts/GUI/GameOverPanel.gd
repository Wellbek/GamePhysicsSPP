extends Panel

var processed = false

onready var waveLabel = get_node("Message/Wave")

func _process(_delta):
	if !processed && visible:
		processed = true;
		init_screen()

func init_screen():
	PlayerVariables.inMenu = true
	waveLabel.text = str(PlayerVariables.wave_manager().wave)
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_RestartButton_button_up():
	PlayerVariables.reset_variables()
	get_tree().change_scene("res://Scenes/MainScene.tscn")


func _on_MenuButton_button_up():
	get_tree().paused = false
	PlayerVariables.reset_variables()
	get_tree().change_scene("res://Scenes/TitleScreen.tscn")
