extends KinematicBody2D
class_name Actor

var direction = 1 setget set_direction
var velocity = Vector2(0, 0) setget set_velocity

export (bool) var is_role = false
onready var state_machine :StateMachine= $state_machine
onready var input_state_manage :InputStateManage= $input_state_manage
onready var weapon_system :WeaponSystem = $weapon_system
onready var animations = $animations

var LEFT   = "LEFT"
var RIGHT  = "RIGHT"
var JUMP   = "JUMP"
var ATTACK = "ATTACK"

var GRAVITY = 80
var MAX_FALL_SPEED = 2000
var FLOOR_NORMAL = Vector2(0, -1)
var WALK_SPEEP
var FALL_THRESHOLD = 100

func _init_data():
	pass

func _ready():
	_init_data()
	input_state_manage.set_state_machine(self,state_machine)
	state_machine.set_actor(self)
	state_machine.change_state("idle")
	print(input_state_manage)
	print(weapon_system)
	print(input_state_manage)
	
func set_velocity(value):
	velocity = value

func set_direction(value):
	direction = value
	emit_signal("direction_changed", value)

func _process(delta):
	velocity.y += GRAVITY
	velocity.y = min(velocity.y, MAX_FALL_SPEED)
	velocity = move_and_slide(velocity,FLOOR_NORMAL)

	state_machine.process(delta)
	pass

func send_key_input_event(key,pressed):
	input_state_manage.custom_input_envet(key,pressed)

func walk():
	state_machine.change_state("walk")
	
func idle():
	state_machine.change_state("idle")

func jump():
	state_machine.change_state("jump")

func fall():
	state_machine.change_state("fall")

func attack():
	state_machine.change_state("attack")

func get_cur_state():
	return state_machine.state

func get_state_machine():
	return state_machine

func _on_state_exit():
	pass
