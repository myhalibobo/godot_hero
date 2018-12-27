extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var direction = 1

func _ready():
	pass
	
func random_range(a,b):
	return randi() % b + a

func show_blood(origin_position):
	var arr_ins = []
	

	for i in range(15):
		var body = preload("res://effects/blood1.tscn").instance()
		arr_ins.append(body)
		
	var width = 5
	var height = 5
	arr_ins.shuffle()
	var speed = 300
	for ins in arr_ins:
		
		var x = random_range(0,5)
		var y = random_range(0,5)
		var radian = PI/180 * rand_range(181,360)
		var direction = Vector2(cos(radian),sin(radian))
		ins.apply_central_impulse(direction*speed)
		ins.angular_velocity = random_range(-5,5)
		add_child(ins)
		ins.position = Vector2(origin_position.x + x,origin_position.y+y)
		ins.gravity_scale = 10

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
#func _on_timer_shoot_timeout():
#	var arr_ins = []
#	var body = preload("res://effects/body.tscn").instance()
#	var hand1 = preload("res://effects/hand.tscn").instance()
#	var hand2 = preload("res://effects/hand.tscn").instance()
#	var head = preload("res://effects/head.tscn").instance()
#	var leg = preload("res://effects/leg.tscn").instance()
#	arr_ins.push_back(body)
#	arr_ins.push_back(hand1)
#	arr_ins.push_back(hand2)
#	arr_ins.push_back(head)
#	arr_ins.push_back(leg)
#	var width = 5
#	var height = 5
#	arr_ins.shuffle()
#	var speed
#	for ins in arr_ins:
#		var x = random_range(0,5)
#		var y = random_range(0,5)
#		var radian = PI/180 * rand_range(181,360)
#		var direction = Vector2(cos(radian),sin(radian))
#		arr_ins.apply_central_impulse(direction*speed)

