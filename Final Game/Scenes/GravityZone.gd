extends Area

onready var player = PlayerVariables.player()

func _on_Area_body_entered(body):
	if body == player:
		player.cur_gravity *= -1


func _on_Area_body_exited(body):
	if body == player:
		player.cur_gravity *= -1
