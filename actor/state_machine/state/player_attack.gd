extends "../state.gd"

export (float) var wait_time = 0.15

func _ready():
	pass

func enter(actor:Actor):
	pass

func input_process(actor, event):
	if event is InputEventMouseButton and event.is_pressed():
		var direction_vec = Vector2(cos(actor.hand.rotation) * actor.emit_direction,sin(actor.hand.rotation)) 
		var ratation_value = direction_vec.angle()
		actor.weapon_system.shoot(direction_vec,ratation_value)
	
func process(actor, delta):
	pass

func exit(actor):
	pass

