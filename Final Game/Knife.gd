extends Spatial

onready var anim = $AnimationPlayer
onready var area = $Area

var damage = 20

var quick_attack = false

var debug = false

var target = []
var did_damage = []

func _ready():
	anim.playback_speed = 0.5
	area.monitoring = true

func increase_attack_speed(var amount):
	anim.playback_speed *= amount

func _process(delta):		
	if not is_visible(): 
		if area.monitoring:
			area.monitoring = true
		if anim.current_animation == "knife_attack_anim":
			anim.play("knife_idle_anim")
		return
		
	if Input.is_action_just_pressed("shoot") and anim.current_animation != "knife_attack_anim":
		start_attack(false)
		
func start_attack(var q_a):
	quick_attack = q_a
	
	anim.play("knife_attack_anim")
	area.monitoring = true

func attack(var body):
	# sometimes body becomes null for some reason 
	if body == null || not is_visible(): return
	
	# print(body)
	
	if body.is_in_group("Enemy"):
		if body.has_method('take_damage'):
			body.take_damage(damage)
		elif debug:
			print("NoSuchMethodError: take_damage() in " + body.get_script().get_path())

func _on_AnimationPlayer_animation_finished(anim_name):
	anim.play("knife_idle_anim")
	did_damage = []
	
	if quick_attack:
		quick_attack = false
		get_parent().swap_weapon(1)

func _on_Area_body_exited(body):
	var ind = target.find(body.get_parent())
	if ind == -1: return
	
	target.remove(ind)

func _on_Area_body_entered(body):
	if anim.current_animation != "knife_attack_anim" || target.has(body.get_parent()): return
	
	if body.is_in_group("Enemy"): 
		target.append(body.get_parent())
		did_damage.append(body.get_parent())
		attack(body)


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "knife_attack_anim":
		for body in target:
			attack(body.get_node("torso"))
			did_damage.append(body.get_parent())
