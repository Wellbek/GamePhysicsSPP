extends MeshInstance

onready var enemy = preload("res://Instances/ogre.tscn")
onready var timer = get_node("Timer")
onready var navigation = get_parent().get_parent() # ugly hardcoded change later

func _on_Timer_timeout():
	var enemy_instance = enemy.instance()
	enemy_instance.transform.origin = transform.origin
	
	navigation.add_child(enemy_instance)
