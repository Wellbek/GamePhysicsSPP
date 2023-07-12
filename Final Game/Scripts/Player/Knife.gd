extends Spatial

onready var anim = $AnimationPlayer
onready var area = $Area

var damage = 15

var quick_attack = false

var debug = false

var targets = []

func _ready():
	anim.playback_speed = 0.5
	area.monitoring = true

func increase_attack_speed(var amount):
	anim.playback_speed *= amount
	
func decrease_attack_speed(var amount):
	anim.playback_speed /= amount

func _process(delta):		
	if not is_visible(): 
		if anim.current_animation == "knife_attack_anim":
			anim.play("knife_idle_anim")
					
	elif Input.is_action_just_pressed("shoot") and anim.current_animation != "knife_attack_anim":
		start_attack(false)
		
func start_attack(var q_a):
	if is_visible():
		quick_attack = q_a
		
		anim.play("knife_attack_anim")

func attack():
	if not is_visible(): return
	
	var size = targets.size()
	var i = 0
	
	while i < size:
		
		var body = targets[i].get_node("torso")
		# sometimes the body becomes null for some reason
		if body == null:
			targets.remove(i)
			size -= 1
			continue
		
		if body.is_in_group("Enemy"):
			if body.enemy_root.dead:
				targets.remove(i)
				size -= 1
				continue 
			
			if body.has_method('take_damage'):
				body.take_damage(damage)
			elif debug:
				print("NoSuchMethodError: take_damage() in " + body.get_script().get_path())
		i += 1

func _on_AnimationPlayer_animation_finished(anim_name):
	anim.play("knife_idle_anim")
	
	if quick_attack:
		quick_attack = false
		get_parent().swap_weapon(1)

func _on_Area_body_exited(body):
	var ind = targets.find(body.get_parent())
	if ind == -1: return
	
	targets.remove(ind)
	
	if debug: print(targets)

func _on_Area_body_entered(body):
	if targets.has(body) || targets.has(body.get_parent()): return
	
	if body.is_in_group("Enemy"): 
		targets.append(body.get_parent())
		
	if debug: print(targets)

func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "knife_attack_anim":
		attack()
