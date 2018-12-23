extends "../state.gd"

export (int) var speed = 200

func enter(actor:Actor):
	actor.animations.play("walk")

func input_process(actor, event):
	#-----------------pressed------------#
	if event.is_action_pressed(actor.ATTACK):
		actor.attack()
	if event.is_action_pressed(actor.JUMP):
		actor.jump()

	if event.is_action_pressed(actor.RIGHT):
		actor.direction = 1
		actor.velocity.x = speed * actor.direction
	if event.is_action_pressed(actor.LEFT):
		actor.direction = -1
		actor.velocity.x = speed * actor.direction
	#-----------------released------------#
	#同时按下左右两个按键时候，松开其中一个键，角色会朝没有没有释放的按键方向移动
	if event.is_action_released(actor.RIGHT) and actor.direction == 1:
		if actor.input_state_manage.is_action_pressed(actor.LEFT):
			actor.direction = -1
			actor.velocity.x = speed * actor.direction
		else:
			actor.idle()
	if event.is_action_released(actor.LEFT) and actor.direction == -1:
		if actor.input_state_manage.is_action_pressed(actor.RIGHT):
			actor.direction = 1
			actor.velocity.x = speed * actor.direction
		else:
			actor.velocity.x = speed * actor.direction
			actor.idle()
			
func process(actor, delta):
	if actor.get_slide_count() < 1:
		if actor.velocity.y > actor.FALL_THRESHOLD:
			actor.fall()
		return
	var collision = actor.get_slide_collision(0)
	if abs(rad2deg(collision.normal.angle())) > 90:
		actor.velocity = Vector2(speed * actor.direction, 0)


func exit(actor:Actor):
	actor.animations.stop()

	