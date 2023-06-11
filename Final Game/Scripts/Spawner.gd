extends Spatial

export(NodePath) onready var navigation = get_node(navigation)

onready var wm = PlayerVariables.wave_manager
var rng = RandomNumberGenerator.new()

export var spread = 0

func _ready():
	rng.randomize() # get "true" random numbers

func spawn_enemy(var enemy):
	var enemy_instance = enemy.instance()
	enemy_instance.transform.origin = get_new_position() 
	
	enemy_instance = randomize_enemy(enemy_instance, 1, 0.3)
	
	var attribute_amplifier = 1.0 + (float(wm.wave) / 30) # the higher the wave the stronger the enemies
	
	enemy_instance.speed *= attribute_amplifier
	enemy_instance.attack_speed *= attribute_amplifier
	enemy_instance.damage *= attribute_amplifier
	enemy_instance.max_health *= attribute_amplifier
	enemy_instance.health = enemy_instance.max_health
	
	navigation.add_child(enemy_instance)
	
func get_new_position():
	var res = transform.origin
	if spread == 0:
		return res
	
	var diff = Vector3(1,0,0).rotated(Vector3(0,1,0), randf() * 2*PI) * randf()*spread
	
	res = res + diff
	
	return res

func randomize_enemy(var _enemy, var _mean, var _deviation):
	
	var ran = rng.randfn(_mean, _deviation)
	ran = clamp(ran, 0.3, 10)
	
	_enemy.speed /= ran
	_enemy.damage *= ran
	#_enemy.attack_speed /= ran #I took this out since this evens out the damage debuff/buff so it doesnt really matter wether the enemy is big or small (the babies were too powerful xd)
	_enemy.max_health *= ran
	_enemy.health = _enemy.max_health
	
	_enemy.scale *= ran
	
	return _enemy
