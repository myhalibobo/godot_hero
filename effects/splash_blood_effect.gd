extends Node2D

var blood1_tscn = preload("res://effects/blood1.tscn")
var blood_node
var origin_position
var count = 0
onready var timer = $timer

func _ready():
	blood_node = get_tree().get_root().get_node("game_scene").get_node("blood_node")
	
func random_range(a,b):
	return randi() % b + a

func show_blood(_origin_position):
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
		queue_free()





