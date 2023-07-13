extends Control

func _on_CheckBox_toggled(button_pressed):
	PlayerVariables.cheats_enabled = button_pressed


func _on_Button_button_up():
	PlayerVariables.reset_variables()
	get_tree().change_scene("res://Scenes/MainScene.tscn")
