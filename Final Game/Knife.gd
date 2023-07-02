extends Spatial

onready var anim = $AnimationPlayer
onready var area = $Area

var damage = 20

var quick_attack = false

var debug = false

# NOTE: not best solution (allows us to only hit one enemy at a time) BUT allows us to dismiss many other issues
var target = false

func _ready():
	anim.playback_speed = 0.5
	area.monitoring = false

func increase_attack_speed(var amount):
	anim.playback_speed *= amount

func _process(delta):		
	if not is_visible(): 
		if area.monitoring:
			area.monitoring = false
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
	area.monitoring = false
	target = false
	
	if quick_attack:
		quick_attack = false
		get_parent().swap_weapon(1)

func _on_Area_body_entered(body):
	if target: return
	
	if body.is_in_group("Enemy"): 
		target = true
		area.monitoring = false
		attack(body)
