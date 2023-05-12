extends Spatial


onready var bow_animator = $AnimationPlayer

func _process(delta):
	if Input.is_action_just_pressed("shoot"):
		bow_animator.play("bow_draw_animation")
		
	if Input.is_action_just_released("shoot"):
		bow_animator.stop(true) # stops current animation
		bow_animator.seek(0, true) # resets animation to default
		
		# To Do: Shoot the actual projectile here
