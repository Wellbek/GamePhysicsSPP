extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")

func _on_Area_area_entered(body):
	print(body.name)
	print("test")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
