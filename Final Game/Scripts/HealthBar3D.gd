extends Sprite3D

func _ready():
	texture = $Viewport.get_texture()

func _physics_process(delta):
	look_at(PlayerVariables.player.global_transform.origin, Vector3.UP)
