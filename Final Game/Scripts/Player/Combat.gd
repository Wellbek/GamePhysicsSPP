extends Spatial

onready var bow_animator = $AnimationPlayer

onready var arrow_scene = load("res://Instances//Entities//arrow.tscn")

var arrow_impulse_multiplier = 50
var req_draw = 0.2 # seconds how long to draw bow to be able shoot

func _process(delta):	
	if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE: return
	
	if Input.is_action_just_pressed("shoot"):
		bow_animator.play("bow_draw_animation")
		
	if Input.is_action_just_released("shoot"):
		# only shoot if bow is drawn enough
		var anim_frac = bow_animator.current_animation_position/bow_animator.current_animation_length
		if anim_frac >= req_draw:
			# Shoot the projectile 
			var arrow = arrow_scene.instance()
			
			arrow.transform.origin = get_parent().global_transform.origin
			arrow.rotation = get_parent().global_transform.basis.get_euler()
			arrow.apply_central_impulse(-get_parent().global_transform.basis.z * arrow_impulse_multiplier * anim_frac)
			arrow.damage = anim_frac * PlayerVariables.damage
			
			get_tree().root.add_child(arrow)
		
		
		# reset bow animation
		bow_animator.stop(true) # stops current animation
		bow_animator.seek(0, true) # resets animation to default
