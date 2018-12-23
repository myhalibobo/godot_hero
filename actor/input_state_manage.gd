extends Node
class_name InputStateManage

var state_machine
var actor

var inputArr


func _ready():
	pass

func set_state_machine(_actor,_state_machine):
	actor = _actor
	state_machine = _state_machine
	inputArr = {
		actor.LEFT 	 : false,
		actor.RIGHT	 : false,
		actor.JUMP 	 : false,
		actor.ATTACK   : false,
	}

func _input(event):
	if actor.is_role and state_machine.state:
		if event.is_action_pressed(actor.LEFT):
			inputArr[actor.LEFT] = true
		if event.is_action_pressed(actor.RIGHT):
			inputArr[actor.RIGHT] = true
		if event.is_action_released(actor.LEFT):
			inputArr[actor.LEFT] = false
		if event.is_action_released(actor.RIGHT):
			inputArr[actor.RIGHT] = false
		state_machine.state.input_process(actor, event)
		state_machine.global_state.input_process(actor, event)
	pass

func is_action_pressed(action):
	return inputArr[action]

func is_action_released(action):
	return !inputArr[action]

func custom_input_envet(action , pressed):
	if actor.is_role:
		var code 
		match action:
			actor.LEFT:
				code = KEY_A
			actor.RIGHT:
				code = KEY_D
			actor.JUMP:
				code = KEY_K
		var ev = InputEventKey.new()
		ev.scancode = code
		ev.pressed = pressed
		Input.parse_input_event(ev)
		return
	
	if pressed and inputArr[action] == pressed:
		_print_input_info("按下:" + action)
	elif not pressed and inputArr[action] == pressed:
		_print_input_info("释放：" + action)
	inputArr[action] = pressed
	state_machine.state.input_process(actor, self)

#-----------------debug------------------#
export (bool) var is_open_input = false
func _print_input_info(info):
	if not is_open_input:
		return
	print("input:" + info)