extends Spatial

func _ready():
	var ball = load("res://Ball.tscn")
	var ballCop = ball.instace()
	add_child(ballCop)

#func spawn_Ball():
#	var ball = load("res://Ball.tscn")
#	var ballCop = ball.instace()
#	add_child(ballCop)

#func _input(event):
#	if Input.is_mouse_button_pressed(1):
#		print("a")
#		spawn_Ball()

func _process(delta):
	pass