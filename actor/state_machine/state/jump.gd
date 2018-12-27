extends "../state.gd"

export (int) var jump_height = 1500
export (int) var max_jumps = 1
export (float) var MAX_WALL_SPEED = 500

onready var jumps = max_jumps setget set_jumps
var in_air_speed = 400.0
var is_released_jump = false
var small_move_x_flag = false #起跳碰到然后跳过障碍时候，降低velocity.x的值，使角色看来自然一点
var next_change_state

func enter(actor):
	in_air_speed = 500#get_node("../walk").speed
	actor.velocity.y = -jump_height
	actor.animations.play("jump")

func input_process(actor, event):
	#----------------pressed------------#
	if event.is_action_pressed(actor.RIGHT):
		actor.direction = 1
		actor.velocity.x = in_air_speed * actor.direction
	elif event.is_action_pressed(actor.LEFT):
		actor.direction = -1
		actor.velocity.x = in_air_speed * actor.direction
	if event.is_action_pressed(actor.ATTACK):
		actor.attack()
	#----------------released------------#
	if event.is_action_released(actor.LEFT) or event.is_action_released(actor.RIGHT):
		actor.velocity.x = 0
	if event.is_action_released(actor.JUMP):
		is_released_jump = true

func process(actor, delta):
	if actor.velocity.y > actor.FALL_THRESHOLD:
		actor.fall()

	if actor.is_on_floor():
		if actor.input_state_manage.is_action_pressed(actor.RIGHT):
			actor.direction = 1
			actor.walk()
		elif actor.input_state_manage.is_action_pressed(actor.LEFT):
			actor.direction = -1
			actor.walk()
		else:
			actor.idle()
	
	if not small_move_x_flag:
		if actor.input_state_manage.is_action_pressed(actor.RIGHT):
			actor.direction = 1
			actor.velocity.x = in_air_speed * actor.direction
		elif actor.input_state_manage.is_action_pressed(actor.LEFT):
			actor.direction = -1
			actor.velocity.x = in_air_speed * actor.direction

	if actor.is_on_wall():
		var normal = actor.get_slide_collision(0).normal
		if actor.input_state_manage.is_action_pressed(actor.RIGHT) and sign(normal.x) == -1:
			actor.velocity.x += actor.GRAVITY * -sign(normal.x) * 2
		elif actor.input_state_manage.is_action_pressed(actor.LEFT) and sign(normal.x) == 1:
			actor.velocity.x += actor.GRAVITY * -sign(normal.x) * 2
		actor.velocity.x = clamp(actor.velocity.x, -MAX_WALL_SPEED, MAX_WALL_SPEED)
		small_move_x_flag = true

func exit(actor):
	actor.animations.stop()

func set_jumps(value):
	jumps = value
	jumps = clamp(jumps, 0, max_jumps)
