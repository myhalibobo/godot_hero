extends "../actor.gd"

onready var ai :AiBase= $ai
var local_collision_pos
var blood_effect

func _ready():
	pass

func _process(delta):
	animations.scale.x = abs(animations.scale.x) * direction
#	ai.hover_move()
	if HP == 0:
		dead()

func _integrate_forces(state):
    if(state.get_contact_count() >= 1):  #this check is needed or it will throw errors 
        local_collision_pos = state.get_contact_local_pos(0)
		blood_effect.show_blood(local_collision_pos)
	
func dead():
	queue_free()