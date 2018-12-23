extends "../state.gd"

export (float) var wait_time = 0.15

func _ready():
	pass

func enter(actor:Actor):
	pass

func input_process(actor, event):
	if event is InputEventMouseButton and event.is_pressed():
		actor.weapon_system.shoot()
	
func process(actor, delta):
	
	pass

func exit(actor):
	pass

