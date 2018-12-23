extends Node
signal state_exit
var is_cding = false
var timer_cd

func _ready():
	timer_cd = Timer.new()
	timer_cd.one_shot = true
	timer_cd.connect("timeout",self,"_on_timer_cd")
	add_child(timer_cd)
	
	set_process_input(false)
	set_process(false)
	set_physics_process(false)
	
func input_process(actor, event):
	pass
	
func enter(actor):
	pass
	
func exit(actor):
	emit_signal("state_exit")
	pass

func on_massage():
	pass
	
func hurt(actor):
	pass
	
func _on_timer_cd():
	is_cding = false
