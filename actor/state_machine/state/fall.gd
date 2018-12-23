extends "../state.gd"

var in_air_speed = 400
export (float) var MAX_FALL_SPEED = 2000

func enter(actor):
	actor.animations.play("fall")
	in_air_speed = get_node("../walk").speed


func input_process(actor:Actor, event):
	if event.is_action_pressed(actor.RIGHT):
		actor.direction = 1
		actor.velocity.x = in_air_speed * actor.direction
	elif event.is_action_pressed(actor.LEFT):
		actor.direction = -1
		actor.velocity.x = in_air_speed * actor.direction

	if event.is_action_released(actor.RIGHT):
		actor.velocity.x = 0
	elif event.is_action_released(actor.LEFT):
		actor.velocity.x = 0
	
	if event.is_action_pressed(actor.ATTACK):
		actor.attack()

func process(actor, delta):

	actor.velocity.y = min(actor.velocity.y, MAX_FALL_SPEED)

	if actor.input_state_manage.is_action_pressed(actor.RIGHT):
		actor.direction = 1
		actor.velocity.x = in_air_speed * actor.direction
	elif actor.input_state_manage.is_action_pressed(actor.LEFT):
		actor.direction = -1
		actor.velocity.x = in_air_speed * actor.direction

	if actor.is_on_floor():
		if actor.input_state_manage.is_action_pressed(actor.RIGHT):
			actor.direction = 1
			actor.walk()
		elif actor.input_state_manage.is_action_pressed(actor.LEFT):
			actor.direction = -1
			actor.walk()
		else:
			actor.idle()
			
func exit(actor:Actor):
	actor.animations.stop()
