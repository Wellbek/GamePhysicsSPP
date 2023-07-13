extends Panel

onready var timer = get_node("Timer")
onready var label = get_node("HSplitContainer/Label")
onready var progress = get_node("HSplitContainer/TextureProgress")

onready var player = PlayerVariables.player()

var buff

enum BuffType{
	JUMP_BOOST,
	SPEED_BOOST,
	DOUBLE_DAMAGE,
	EXTRA_JUMPS,
	ATTK_SPEED_BOOST
	RANGE_BOOST,
	EXTRA_ARROWS,
}

func enum_to_string(var enum_value):
	var enum_str = str(enum_value)
	enum_str = enum_str.replace("_", " ")
	enum_str = enum_str.to_lower()
	return enum_str.capitalize()
	
func apply_boost():
	match BuffType[buff]:
		BuffType.JUMP_BOOST:
			player.jump_strength *= 2
		BuffType.SPEED_BOOST:
			player.accelaration_speed *= 1.6
			player.accelaration_speed_in_air *= 1.6
			player.max_speed *= 2
		BuffType.DOUBLE_DAMAGE:
			PlayerVariables.bow_combat().damage *= 2
			PlayerVariables.knife_combat().damage *= 2
		BuffType.EXTRA_JUMPS:
			player.number_of_extra_jumps += 5
		BuffType.ATTK_SPEED_BOOST:
			PlayerVariables.bow_combat().increase_attack_speed(2)
			PlayerVariables.knife_combat().increase_attack_speed(2)
		BuffType.RANGE_BOOST:
			PlayerVariables.bow_combat().shoot_range *= 2
		BuffType.EXTRA_ARROWS:
			PlayerVariables.bow_combat().number_of_arrows += 2
			
func clear_boost():
	match BuffType[buff]:
		BuffType.JUMP_BOOST:
			player.jump_strength /= 2
		BuffType.SPEED_BOOST:
			player.accelaration_speed /= 1.6
			player.accelaration_speed_in_air /= 1.6
			player.max_speed /= 2
		BuffType.DOUBLE_DAMAGE:
			PlayerVariables.bow_combat().damage /= 2
			PlayerVariables.knife_combat().damage /= 2
		BuffType.EXTRA_JUMPS:
			player.number_of_extra_jumps -= 5
		BuffType.ATTK_SPEED_BOOST:
			PlayerVariables.bow_combat().decrease_attack_speed(2)
			PlayerVariables.knife_combat().decrease_attack_speed(2)
		BuffType.RANGE_BOOST:
			PlayerVariables.bow_combat().shoot_range /= 2
		BuffType.EXTRA_ARROWS:
			PlayerVariables.bow_combat().number_of_arrows -= 2
			
	queue_free()

func _ready():
	var buffs = BuffType.keys()
	
	var random = randi() % buffs.size()
	buff = buffs[random]
	
	label.text = enum_to_string(buff)
	
	apply_boost()

func _process(_delta):
	if timer.wait_time > 0:
		progress.value = float(timer.time_left)/float(timer.wait_time) * 100

func _on_Timer_timeout():
	clear_boost()
