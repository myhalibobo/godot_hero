extends "../state.gd"
	
func enter(actor):
	actor.velocity.x = 0
	actor.animations.play("idle")

func input_process(actor, event):
	if event.is_action_pressed(actor.JUMP):
		actor.jump()
	if event.is_action_pressed(actor.RIGHT):
		actor.direction = 1
		actor.walk()
	if event.is_action_pressed(actor.LEFT):
		actor.direction = -1
		actor.walk()
	if event.is_action_pressed(actor.ATTACK):
		actor.attack()

func process(actor, delta):
	pass

func exit(actor):
	actor.animations.stop()
