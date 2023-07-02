extends Camera

# index of weapon active on start
# #NOTE: change this number to select which weapon to use on startup!
var curr = 0

func _ready():
	for child in get_children():
		child.hide()
		
	get_child(curr).show()

func _process(delta):
	if Input.is_key_pressed(KEY_1) and curr != 0:
		swap_weapon(0)
		# print("Knife selected")
	if Input.is_key_pressed(KEY_2) and curr != 1:
		swap_weapon(1)
		# print("Bow selected")
		
func swap_weapon(var i):
	var old = get_child(curr)
	var new = get_child(i)
	old.hide()
	new.show()
	curr = i
