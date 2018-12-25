extends Node
class_name AiBase
export (NodePath) var actor_path
var actor

var detect_info
var look_for_flag = false
var input_state_manage
var label_ai

func _ready():
	actor = get_node(actor_path)
	input_state_manage = actor.get_node("input_state_manage")
	
func hover_move():
	if is_arrive_left_border():
		move_right()
	elif is_arrive_right_border():
		move_left()
	else:
		move_forward()

func stop_move():
	if not input_state_manage.is_action_released(actor.RIGHT):
		actor.send_key_input_event(actor.RIGHT , false)
	if not input_state_manage.is_action_released(actor.LEFT):
		actor.send_key_input_event(actor.LEFT , false)

func move_forward():
	if actor.direction == 1 and not input_state_manage.is_action_pressed(actor.RIGHT): 
		move_right()
	if actor.direction == -1 and not input_state_manage.is_action_pressed(actor.LEFT):
		move_left()

func is_arrive_left_border():
	if actor.is_on_floor():
		if actor.detect_info.is_left_down_is_air():
			return true
		if actor.detect_info.is_left_collision_obstacles():
			return true
	return false

func is_arrive_right_border():
	if actor.is_on_floor():
		if actor.detect_info.is_rignt_down_is_air():
			return true
		if actor.detect_info.is_right_collision_obstacles():
			return true
	return false

func move_right():
	actor.send_key_input_event(actor.RIGHT,true)
	actor.send_key_input_event(actor.LEFT,false)

func move_left():
	actor.send_key_input_event(actor.LEFT,true)
	actor.send_key_input_event(actor.RIGHT,false)
