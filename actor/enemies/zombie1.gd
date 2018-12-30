extends "../actor.gd"

onready var ai :AiBase= $ai
var local_collision_pos
var blood_effect
var world_tile_map:TileMap
var player
var path_arr
var next_coord
var jumpTimer
var pre_map_coord
var zombie_node
onready var free_timer = $free_timer
onready var timer_dead_delay = $timer_dead_delay

var delay_action
var ui
var is_dead = false

func _ready():
	world_tile_map = get_tree().get_root().get_node("game_scene").get_node("tilemap")
	player = get_tree().get_root().get_node("game_scene").get_node("player")
	jumpTimer = Timer.new()
	jumpTimer.one_shot = true
	jumpTimer.connect("timeout",self,"_on_jump_timer_timeout") 
	add_child(jumpTimer)
	zombie_node = get_tree().get_root().get_node("game_scene").get_node("zombie_node")
	ui = get_tree().get_root().get_node("game_scene").get_node("ui")

func set_rigidbody(rigid):
	print(rigid.name)
	rigid.mass = 100.0
	rigid.gravity_scale = 100.0
	rigid.friction = 0.5
	rigid.linear_damp = 0.1

func _process(delta):
	if is_dead:
		if timer_dead_delay.is_stopped():
			timer_dead_delay.start()
			remove_child($pinJoint_body)
			remove_child($pinJoint_hand)
			remove_child($pinJoint_head)
			remove_child($animations)
			set_rigidbody($body_rigid)
			set_rigidbody($head_rigid)
			set_rigidbody($hand_rigid)
		set_process(false)
		return
		
	animations.scale.x = abs(animations.scale.x) * direction
	_execute_trace()
	
	if is_activity == false:
		if free_timer.is_stopped():
			free_timer.start()
	else:
		if not free_timer.is_stopped():
			free_timer.stop()
	if HP == 0:
		dead()
	if path_arr == null:
		ai.hover_move()

func dead():
	if HP == 0:
		ui.add_kill_num()
		is_dead = true

	
func reduce_blood(reduce_value):
	.reduce_blood(reduce_value)

		

func trace_move():
	if not is_on_floor():
		return
	print("寻路")
	var start = world_tile_map.world_to_map(position + Vector2(0,-32))
	var end_pos = get_end_pos(start)
	var success = start_pathfinding_and_move(end_pos)
#	if success:
#		path_arr = null

func check_coord_has_zombie(next_coord):
	for child in zombie_node.get_children():
		var coord = world_tile_map.world_to_map(child.position + Vector2(0,-32))
		if coord == next_coord:
			return true
		return false
	
func get_end_pos(start):
	var end = world_tile_map.world_to_map(player.position)
	end.x = floor(end.x / world_tile_map.scale.x)
	end.y = floor(end.y / world_tile_map.scale.y)
	var interrupt_count = 0
	for i in range(18):
		var id = world_tile_map.get_cell(end.x,end.y)
		if id != -1:
			end.y = end.y - 1
			break
		end.y += 1
		if end.y >= start.y:
			interrupt_count += 1
	if interrupt_count > 3:
		return start
	return end

func start_pathfinding_and_move(end_pos):
	var start = world_tile_map.world_to_map(position+ Vector2(0,-32))
	start.x = floor(start.x / world_tile_map.scale.x)
	start.y = floor(start.y / world_tile_map.scale.y)
	if start == end_pos:
		return false
	path_arr = path_finder_fast.find_path(start,end_pos,1,2,1)
	if path_arr:
		path_arr.append(start)
		print("path:",path_arr)
		next_coord = path_arr.pop_back()
	return true
	
func _execute_trace():
	if path_arr != null:
		var role_coord = _get_position_tile_map_coord()
		if role_coord != pre_map_coord:
			print("role:",role_coord)
			pre_map_coord = role_coord
		if is_reach_target(role_coord,next_coord):
			if path_arr.size() == 0:
				pathfinding_end()
				return
			next_coord  = path_arr.pop_back()
			print("pop:",next_coord)
			return
		if check_coord_has_zombie(next_coord):
				$timer_delay_action.wait_time = 1
				$timer_delay_action.stop()
				$timer_delay_action.start()
				delay_action = true
				return
		if delay_action:
			return
		if role_coord.x == next_coord.x and role_coord.y < next_coord.y and not is_on_floor():
			for i in range(next_coord.y - role_coord.y):
				if world_tile_map.get_cell(next_coord.x ,next_coord.y + i) != -1:
					return false
			send_key_input_event(LEFT,false)
			send_key_input_event(RIGHT,false)
		#向左走
		if role_coord.x > next_coord.x and not input_state_manage.is_action_pressed(LEFT) and is_on_floor():
			send_key_input_event(LEFT,true)
			send_key_input_event(RIGHT,false)
		#想右走
		if role_coord.x < next_coord.x and not input_state_manage.is_action_pressed(RIGHT)and is_on_floor():
			send_key_input_event(RIGHT,true)
			send_key_input_event(LEFT,false)

		if role_coord.x == next_coord.x and role_coord.y < next_coord.y and is_on_floor():
			if is_collide_with_down_left() and not input_state_manage.is_action_pressed(RIGHT):
				send_key_input_event(RIGHT,true)
				send_key_input_event(LEFT,false)
			if is_collide_with_down_right() and not input_state_manage.is_action_pressed(LEFT):
				send_key_input_event(LEFT,true)
				send_key_input_event(RIGHT,false)

		if role_coord.y > next_coord.y and not input_state_manage.is_action_pressed(JUMP):
			if not is_jump_collide_with_top_left_top_right():
				var coord = world_tile_map.map_to_world(role_coord,true)
				if jump_direction(role_coord,next_coord) == RIGHT:
					if position.x >= coord.x + 32 and position.x <= coord.x + 64:
						send_key_input_event(JUMP,true)
						send_key_input_event(JUMP,false)
				else:
					if position.x >= coord.x  and position.x <= coord.x + 32:
						send_key_input_event(JUMP,true)
						send_key_input_event(JUMP,false)
	pass

func jump_direction(role_coord,next_coord):
	if role_coord.x > next_coord.x:
		return LEFT
	else:
		return RIGHT

func world_to_map(p):
	var c = world_tile_map.world_to_map(p)
	c.x = floor(c.x / world_tile_map.scale.x)
	c.y = floor(c.y / world_tile_map.scale.y)
	return c

func _get_position_tile_map_coord():
	return world_to_map(position+Vector2(0,-32))

func is_reach_target(roleCoord,nextCoord):
	if roleCoord.x == nextCoord.x and roleCoord.y == nextCoord.y:
		if not is_tile_map_cell_null(Vector2(nextCoord.x,nextCoord.y + 1)):
			if is_on_floor():
				return true
			return false
		return true
	return false

func is_tile_map_cell_null(coord):
	if world_tile_map.get_cell(coord.x,coord.y) == -1:
		return true
	return false
	
func calulate_pathfinding_timer_out_time(cur_pos,next_pos):
	return (abs(cur_pos.x - next_pos.x) + abs(cur_pos.y - next_pos.y)) * 0.4

func pathfinding_end():
	path_arr = null
	send_key_input_event(LEFT,false)
	send_key_input_event(RIGHT,false)
	if input_state_manage.is_action_pressed(JUMP) and is_on_floor():
		jumpTimer.stop()
		_on_jump_timer_timeout()

func _on_jump_timer_timeout():
	send_key_input_event(JUMP,false)
	pass

func get_body_size():
	return Vector2(10,52)
	
func is_collide_with_down_left():
	var size = get_body_size()
	var self_coord = world_to_map(position)
	var down_left_coord = Vector2(self_coord.x - 1, self_coord.y + 1)
	if (not is_tile_map_cell_null(down_left_coord) and
		world_to_map(Vector2(position.x-size.x/2,position.y)).x < self_coord.x):
			return true
	return false

func is_collide_with_down_right():
	var size = get_body_size()
	var self_coord = world_to_map(position)
	var down_right_coord = Vector2(self_coord.x + 1, self_coord.y + 1)
	if (not is_tile_map_cell_null(down_right_coord) and 
		world_to_map(Vector2(position.x + size.x/2,position.y)).x > self_coord.x):
		return true
	return false
	
func is_jump_collide_with_top_left_top_right():
	var size = get_body_size()
	var self_coord = world_to_map(position)
	var top_left_coord = Vector2(self_coord.x - 1, self_coord.y - 1)
	var tt1 = world_to_map(Vector2(position.x-size.x/2 - 3,position.y))
	if (not is_tile_map_cell_null(top_left_coord) and
		world_to_map(Vector2(position.x-size.x/2 - 3,position.y)).x < self_coord.x):
		if not input_state_manage.is_action_pressed(RIGHT):
			send_key_input_event(RIGHT,true)
			send_key_input_event(LEFT,false)
		return true

	var top_right_coord = Vector2(self_coord.x + 1, self_coord.y - 1)
	var tt2 = world_to_map(Vector2(position.x + size.x/2+3,position.y)).x
	if (not is_tile_map_cell_null(top_right_coord) and 
		world_to_map(Vector2(position.x + size.x/2+3,position.y)).x > self_coord.x):
		if not input_state_manage.is_action_pressed(LEFT):
			send_key_input_event(LEFT,true)
			send_key_input_event(RIGHT,false)
		return true
	
	return false

func _on_trace_timer_timeout():
	trace_move()

func _on_free_timer_timeout():
	queue_free()

var attack_body
func _on_attack_area_body_entered(body):
	$attack_timer.stop()
	attack_body = body
	body.reduce_blood(10)
	$attack_timer.wait_time = 1
	$attack_timer.start()

func _on_attack_area_body_exited(body):
	attack_body = null
	$attack_timer.stop()

func _on_attack_timer_timeout():
	if attack_body:
		attack_body.reduce_blood(10)

func _on_timer_delay_action_timeout():
	delay_action = false


func _on_timer_dead_delay_timeout():
	queue_free()
