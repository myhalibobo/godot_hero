extends Node2D

var queue_zombie_postion = []
var count_time
var cur_time = 0
var MAX_ZEMBIE = 10
var zombie1_tscn = preload("res://actor/enemies/zombie1.tscn")

func _process(delta):
	cur_time += delta
	if cur_time > 1:
		cur_time = 0
		create_zombie()

func create_zombie():
	if get_child_count() > MAX_ZEMBIE:
		return
	print("create zombie ........")
	var zombie = zombie1_tscn.instance()
	zombie.position = position
	add_child(zombie)