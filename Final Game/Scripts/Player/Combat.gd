extends Spatial

onready var bow_animator = $AnimationPlayer

onready var arrow_scene = load("res://Instances//Entities//Arrow.tscn")

var number_of_arrows = 1
var shoot_span = 10 # span of multiple arrows in degrees
var shoot_range = 40
var req_draw = 0.4 # seconds how long to draw bow to be able shoot

func _ready():
	bow_animator.playback_speed = 0.5

func increase_attack_speed(var amount):
	req_draw /= amount
	bow_animator.playback_speed *= amount

func _process(delta):		
	if Input.is_action_just_pressed("shoot"):
		bow_animator.play("bow_draw_animation")
		
	if Input.is_action_just_released("shoot"):
		# only shoot if bow is drawn enough
		var anim_frac = bow_animator.current_animation_position/bow_animator.current_animation_length
		if anim_frac >= req_draw:
			# Shoot arrows
			shoot_arrow(number_of_arrows, anim_frac, shoot_span)
		
		# reset bow animation
		bow_animator.stop(true) # stops current animation
		bow_animator.seek(0, true) # resets animation to default


func shoot_arrow(var amount, var anim_frac, var span_degrees):
	span_degrees *= amount
	span_degrees -= 0.5 # normally the lowest possible span is 1 since we devide per upgrade. By subtracting 0.5 our lowest values becomes 0.5
	
	if amount == 1:
		var arrow = arrow_scene.instance()
			
		arrow.transform.origin = get_parent().global_transform.origin
		arrow.rotation = get_parent().global_transform.basis.get_euler()
		
		arrow.apply_central_impulse(-arrow.transform.basis.z * shoot_range * anim_frac)
		arrow.damage = anim_frac * PlayerVariables.damage
		
		get_tree().root.add_child(arrow)
	else:	
		var angle_increment = span_degrees / (amount - 1)  # Calculate the angle increment between each arrow
		var start_angle = -span_degrees / 2  # Calculate the starting angle
		
		for i in range(amount):
			var arrow = arrow_scene.instance()
			
			arrow.transform.origin = get_parent().global_transform.origin
			arrow.rotation = get_parent().global_transform.basis.get_euler()
			
			var rotation_angle = deg2rad(start_angle + i * angle_increment)  # Calculate the rotation angle for each arrow
			var rotation_axis = get_parent().global_transform.basis.y  # Use the parent's up direction as the rotation axis
			
			arrow.rotate(rotation_axis, rotation_angle)  # Rotate the arrow by the calculated angle
			
			arrow.apply_central_impulse(-arrow.transform.basis.z * shoot_range * anim_frac)
			arrow.damage = anim_frac * PlayerVariables.damage
			
			get_tree().root.add_child(arrow)
