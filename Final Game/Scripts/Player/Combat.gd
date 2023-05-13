extends Spatial


onready var bow_animator = $AnimationPlayer

onready var arrow_scene = load("res://Instances//Entities//arrow.tscn")

var arrow_impulse_multiplier = 50

func _process(delta):	
	if Input.is_action_just_pressed("shoot"):
		bow_animator.play("bow_draw_animation")
		
	if Input.is_action_just_released("shoot"):
		# Shoot the projectile 
		var arrow = arrow_scene.instance()
		
		arrow.transform.origin = get_parent().global_transform.origin
		arrow.rotation = get_parent().global_transform.basis.get_euler()
		arrow.get_node("RigidBody").apply_central_impulse(-get_parent().global_transform.basis.z * arrow_impulse_multiplier * bow_animator.current_animation_position/bow_animator.current_animation_length)
		
		
		# reset bow animation
		bow_animator.stop(true) # stops current animation
		bow_animator.seek(0, true) # resets animation to default
		
		get_tree().root.add_child(arrow)
