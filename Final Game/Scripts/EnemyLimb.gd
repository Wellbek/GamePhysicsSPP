extends RigidBody

onready var enemy_root = get_parent().get_parent() # NOTE: ugly hardcoded, change later

export var critical_limb = false # if we want headshots to deal more damage for example

func take_damage(var amount: float):
	if enemy_root != null and enemy_root.has_method("take_damage"):
		if critical_limb:
			enemy_root.take_damage(amount * 2)
		else:
			enemy_root.take_damage(amount)
			
func change_mode(var _mode):
	mode = _mode
