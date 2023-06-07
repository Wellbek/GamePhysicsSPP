extends Spatial

export(NodePath) onready var enemy_root = get_node(enemy_root)
export(NodePath) onready var anim_player = get_node(anim_player)

export var walking_animation: String

func _ready():
	anim_player.play(walking_animation)
	anim_player.playback_speed = enemy_root.speed / 2

func _process(delta):
	if enemy_root.dead: 
		anim_player.stop()
		return
	
	if enemy_root.target != null:
		var my_rot = rotation
		
		# look in walking dir except we are in range to attack
		var look_at_target = global_transform.origin + enemy_root.velocity
		if enemy_root.attack_target != null: 
			look_at_target = enemy_root.attack_target.global_transform.origin
			anim_player.stop(true)
			anim_player.seek(0, true) # resets animation to default
			# play attack anim somewhere here
		else: anim_player.play()
		
		if look_at_target != global_transform.origin: look_at(look_at_target, Vector3.UP)
		rotation.x = my_rot.x
		rotation.z = my_rot.z
