extends MeshInstance

export var despawn_after_seconds: float

export(NodePath) onready var timer = get_node(timer)

func _ready():
	timer.wait_time = despawn_after_seconds

func start_despawn():
	timer.start()

func _on_DespawnTimer_timeout():
	queue_free()
