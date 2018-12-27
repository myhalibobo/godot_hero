extends Node2D

var blood1_tscn = preload("res://effects/blood1.tscn")
var blood_node
var origin_position
var count = 0
onready var timer = $timer

func _ready():
	blood_node = get_tree().get_root().get_node("game_scene").get_node("blood_node")
	pass
	
func random_range(a,b):
	return randi() % b + a

func show_blood(_origin_position):
	timer.start()
	origin_position = _origin_position
	count = 0

func _on_timer_timeout():
	count += 1
	var ins = blood1_tscn.instance()
	var x = random_range(0,5)
	var y = random_range(0,5)
	var radian = PI/180 * rand_range(200,340)
	var direction = Vector2(cos(radian),sin(radian))
	blood_node.add_child(ins)
	ins.angular_velocity = random_range(-5,5)
	ins.position = Vector2(origin_position.x + x,origin_position.y+y)
	ins.gravity_scale = 10
	ins.apply_central_impulse(direction*rand_range(100,200))
	if count == 15:
		timer.stop()
#func _input(event):
#	if event is InputEventMouseButton and event.is_pressed():
#		var arr_ins = []
#		var body = preload("res://effects/body.tscn").instance()
#		var hand1 = preload("res://effects/hand.tscn").instance()
#		var hand2 = preload("res://effects/hand.tscn").instance()
#		var head = preload("res://effects/head.tscn").instance()
#		var leg = preload("res://effects/leg.tscn").instance()
#		arr_ins.push_back(body)
#		arr_ins.push_back(hand1)
#		arr_ins.push_back(hand2)
#		arr_ins.push_back(head)
#		arr_ins.push_back(leg)
#		var width = 5
#		var height = 5
#		arr_ins.shuffle()
#		var speed = 150
#		for ins in arr_ins:
#
#			var x = random_range(0,5)
#			var y = random_range(0,5)
#			var radian = PI/180 * rand_range(181,360)
#			var direction = Vector2(cos(radian),sin(radian))
#			ins.apply_central_impulse(direction*speed)
#			ins.angular_velocity = random_range(-5,5)
#			add_child(ins)
#			ins.position = Vector2(x,y)
#			ins.gravity_scale = 10




