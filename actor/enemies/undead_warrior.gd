extends "../../actor.gd"
onready var detect_info :DetectInfo= $detect_info
var ai:AiBase
var lock_enemy_action
var attacks_interrupted_num = 0

func _ready():
	ai = $ai
	lock_enemy_action = Lock_enemy_action.new(self)
	
	
func _process(delta):
	if not is_activity:
		return
	if HP == 0:
		return

	if detect_info.is_see_enemy_not_obstructe():
		if detect_info.is_into_attack_range():
			ai.show_ai_info("执行攻击")
			ai.directly_change_to_attack(self)
		else:
			ai.show_ai_info("向目标移动")
			ai.moving_to_target_with_deviation(detect_info.get_attecked_body().position,position,0*scale.x)
		lock_enemy_action.lock_enemy()
	elif lock_enemy_action.is_lock():
		lock_enemy_action.process(delta)
		if detect_info.is_locked_and_detect_enemy():
			ai.show_ai_info("锁定play")
			if detect_info.get_attecked_body().position.x - position.x > 3:
				ai.moving_to_target_with_deviation(detect_info.get_attecked_body().position,position,0*scale.x)
			detect_info.update_memory_body_position()
		elif detect_info.get_memory_body_position():
			ai.show_ai_info("丢失目标，移动记忆点")
			ai.moving_to_target_with_deviation(detect_info.get_memory_body_position(),position,0*scale.x)
	else:
		ai.show_ai_info("巡逻")
		ai.hover_move(self)
	._process1(delta)

func _on_hurt_state_exit():
	var direction =  detect_info.left_right_detect_enemy()
	if direction == LEFT:
		ai.move_left(self)
	elif direction == RIGHT:
		ai.move_right(self)

class Lock_enemy_action:
	var lock_time = 2
	var lock_time_count = 0
	var lock_flag = false
	var actor
	
	func _init(_actor):
		actor = _actor
		
	func process(delta):
		lock_time_count += delta
		if lock_time_count > lock_time:
			exit()
			
	func is_lock():
		return lock_flag
		
	func lock_enemy():
		lock_time_count = 0
		lock_flag = true

	func exit():
		lock_flag = false
		lock_time_count = 0
