extends Camera

onready var marble = get_parent().get_node("Marble")

func _process(delta):
	look_at(marble.global_transform.origin, Vector3.UP)



