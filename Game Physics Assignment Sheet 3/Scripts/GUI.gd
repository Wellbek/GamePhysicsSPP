extends MarginContainer

onready var timer_label = $HBoxContainer/Timer/Background/Label
onready var death_counter_label = $HBoxContainer/DeathCounter/Background/Label
onready var title_label = $HBoxContainer/Title/Background/Label

export var title = "Level x"

func _ready():
	update_death()
	update_timer()
	title_label.text = str(title)

func update_death():
	death_counter_label.text = str(Global.deaths)
	
func update_timer():
	timer_label.text = build_timer_text(Global.minutes, Global.seconds)
	
func build_timer_text(m, s):
	var res = ""
	if m < 10:
		res += "0"
	res += str(m)+":"
	if s < 10:
		res += "0"
	res += str(s)
	return res

