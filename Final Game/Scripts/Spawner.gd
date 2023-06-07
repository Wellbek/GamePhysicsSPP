extends MeshInstance

export(NodePath) onready var navigation = get_node(navigation)

var attribute_amplifier = 1.0 # maybe to progressively get harder the higher wave we are ?

func spawn_enemy(var enemy):
	var enemy_instance = enemy.instance()
	enemy_instance.transform.origin = transform.origin
	
	enemy_instance = randomize_enemy(enemy_instance, 0.5, 1.5)
	
	enemy_instance.speed *= attribute_amplifier
	enemy_instance.attack_speed *= attribute_amplifier
	enemy_instance.damage *= attribute_amplifier
	enemy_instance.max_health *= attribute_amplifier
	enemy_instance.health = enemy_instance.max_health
	
	navigation.add_child(enemy_instance)
	
func randomize_enemy(var _enemy, var _min, var _max):
	randomize() # get "true" random numbers
	
	var ran = rand_range(_min, _max)
	
	_enemy.speed /= ran
	_enemy.damage *= ran
	_enemy.attack_speed /= ran
	_enemy.max_health *= ran
	_enemy.health = _enemy.max_health
	
	_enemy.scale *= ran
	
	return _enemy
