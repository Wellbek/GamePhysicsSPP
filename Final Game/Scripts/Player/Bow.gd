extends Spatial

onready var bow_animator = $AnimationPlayer

onready var arrow_scene = load("res://Instances/Entities/Arrow.tscn")

var number_of_arrows = 1
var shoot_span = 20 # span of multiple arrows in degrees
var shoot_range = 40
var req_draw = 0.4 # seconds how long to draw bow to be able shoot
var damage = 12

func _ready():
	bow_animator.playback_speed = 0.5

func increase_attack_speed(var amount):
	req_draw /= amount
	bow_animator.playback_speed *= amount
	
func decrease_attack_speed(var amount):
	req_draw *= amount
	bow_animator.playback_speed /= amount

func _process(delta):	
	if not is_visible(): 
		# shoot and reset if swapped weapon
		if bow_animator.current_animation == "bow_draw_animation" and bow_animator.current_animation_length != 0:
			shoot()
		return
		
	if Input.is_action_just_pressed("shoot"):
		bow_animator.play("bow_draw_animation")
		
	if Input.is_action_just_released("shoot") && bow_animator.current_animation_length != 0:
		shoot()
		
	if Input.is_action_just_pressed("quick_knife"):
		get_parent().swap_weapon(0)
		get_parent().get_child(0).start_attack(true)


func shoot():
	# only shoot if bow is drawn enough
	var anim_frac = bow_animator.current_animation_position/bow_animator.current_animation_length
	if anim_frac >= req_draw:
		# Shoot arrows
		shoot_arrow(number_of_arrows, anim_frac, shoot_span)
	
	# reset bow animation
	bow_animator.stop(true) # stops current animation
	bow_animator.seek(0, true) # resets animation to default

func shoot_arrow(var amount, var anim_frac, var span_degrees):
	var span_amplifier = 1 + float(amount)/6 # the more arrow the higher the span (to still feel good with low number of arrows)
	var span = pow(span_degrees, span_amplifier) / 10 # exponential growth
	
	span = clamp(span, 0, 3 * span_degrees) # cap growth span_degrees
	
	if amount == 1:
		var arrow = arrow_scene.instance()
			
		arrow.transform.origin = get_parent().global_transform.origin
		arrow.rotation = get_parent().global_transform.basis.get_euler()
		
		arrow.apply_central_impulse(-arrow.transform.basis.z * shoot_range * anim_frac)
		arrow.damage = anim_frac * damage
		
		get_tree().root.add_child(arrow)
	else: 
		var angle_increment = span / (amount - 1)  # Calculate the angle increment between each arrow
		var start_angle = -span / 2  # Calculate the starting angle
		
		for i in range(amount):
			var arrow = arrow_scene.instance()
			
			arrow.transform.origin = get_parent().global_transform.origin
			arrow.rotation = get_parent().global_transform.basis.get_euler()
			
			var rot_angle_deg =(start_angle + i * angle_increment)
			
			var rotation_angle = deg2rad(rot_angle_deg)  # Calculate the rotation angle for each arrow
			var rotation_axis = get_parent().global_transform.basis.y  # Use the parent's up direction as the rotation axis
			
			arrow.rotate(rotation_axis, rotation_angle)  # Rotate the arrow by the calculated angle
			
			arrow.apply_central_impulse(-arrow.transform.basis.z * shoot_range * anim_frac)
			arrow.damage = anim_frac * damage / span_amplifier # scale damage with number of extra arrows
			
			get_tree().root.add_child(arrow)
