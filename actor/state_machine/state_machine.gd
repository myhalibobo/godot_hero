extends Node
class_name StateMachine

export (NodePath) var actor
var previous_state = null
var state_list = []
var state
var global_state

signal state_changed(from, to)

func _ready():
	actor = get_node(actor)
	for child in get_children():
		state_list.append(child.name)
	global_state = get_node("attack")

func set_actor(_actor):
	actor = _actor

func change_state(state_name):
	if not state_list.has(state_name):
		return
	var new_state = get_node(state_name)
	if state != null:
		state.exit(actor)
		_print_input_info("退出："+state.name)
		emit_signal("state_changed", state.name, new_state.name)
		previous_state = state
	else:
		previous_state = new_state
	state = new_state
	state.enter(actor)
	_print_input_info("进入："+state_name)

func process(delta):
	if state:
		state.process(actor,delta)
	if global_state:
		global_state.process(actor,delta)

func get_cur_state():
	return state

func get_state_by_name(state_name):
	if state_list.has(state_name):
		return get_node(state_name)
	
func get_previous_state():
	return previous_state

func change_to_previous_state():
	change_state(previous_state.name)

#-----------------debug----------------- #
export (bool) var is_open_input = false
func _print_input_info(info):
	if not is_open_input:
		return
	print("状态" + info)