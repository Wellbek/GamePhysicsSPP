extends MeshInstance

export var despawn_after_seconds: float

export(NodePath) onready var timer = get_node(timer)

func _ready():
	timer.wait_time = despawn_after_seconds
	
func _process(_delta):
	if PlayerVariables.low_spec_mode && timer.wait_time > 5.0:
		timer.wait_time = 5.0
		if timer.time_left > 0: timer.start() #restart timer
	elif not PlayerVariables.low_spec_mode && timer.wait_time < despawn_after_seconds:
		timer.wait_time = despawn_after_seconds

func start_despawn():
	timer.start()

func _on_DespawnTimer_timeout():
	queue_free()
