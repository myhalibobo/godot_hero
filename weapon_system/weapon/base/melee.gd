extends "weapon.gd"

var polygon_arr = []
var area_arr = []

func _ready():
	init_attack_shape_points_data()
	connect_area2d_atk_body_entered_signal()

func create_frame_area_collision_clear_timer():
	var timer_area_collision_clear = Timer.new()
	timer_area_collision_clear.wait_time = 0.1
	timer_area_collision_clear.one_shot = true
	timer_area_collision_clear.connect("timeout",self,"_on_timer_area_collision_clear_time_out")

func _on_timer_area_collision_clear_time_out():
	for area in area_arr:
		area.monitoring = false
	pass

func connect_area2d_atk_body_entered_signal():
	var count = 1
	while true:
		var path = "area2d_atk"+str(count)
		if has_node(path):
			var area2d_attact_node = get_node(path)
			area2d_attact_node.connect("body_entered",self,"_on_area2d_atk_body_entered")
			area_arr.push_back(area2d_attact_node)
			pass
		else:
			break
		count += 1

func init_attack_shape_points_data():
	var count = 1
	while true:
		var path = "area2d_atk"+str(count)
		if has_node(path):
			var area2d_attact_node = get_node(path)
			var collision_polygon2d = area2d_attact_node.get_node("collision_polygon2d")
			polygon_arr.push_back(collision_polygon2d.polygon)
			pass
		else:
			break
		count += 1
	pass

func flip_polygon_points(polygon):
	var new_polygon = PoolVector2Array()
	for point in polygon:
		var vec_p = Vector2(point.x * -1,point.y)
		new_polygon.push_back(vec_p)
	return new_polygon

func attack():
	pass

func _on_area2d_atk_body_entered(body):
	if body.has_method("reduce_hp"):
		body.reduce_hp(actor,10)
	
func attack_frame_collision(index,is_only_clear_colision):
	for area in area_arr:
		area.monitoring = false
	if is_only_clear_colision:
		return
	
	area_arr[index].monitoring = true
	var collison_polygon = area_arr[index].get_node("collision_polygon2d")
	if actor.direction == 1:
		collison_polygon.polygon = polygon_arr[index]
	else:
		collison_polygon.polygon = flip_polygon_points(polygon_arr[index])