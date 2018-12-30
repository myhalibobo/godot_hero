extends Node2D

var queue_zombie_postion = []
var count_time
var cur_time = 0
var MAX_ZEMBIE = 10
var zombie1_tscn = preload("res://actor/enemies/zombie1.tscn")
var ui
func _ready():
	ui = get_tree().get_root().get_node("game_scene").get_node("ui")

func _process(delta):
	cur_time += delta
	if cur_time > 1:
		cur_time = 0
		create_zombie()
	ui.set_zombie_num(get_child_count())
	
func create_zombie():
	if get_child_count() > MAX_ZEMBIE or queue_zombie_postion.size()==0:
		return
#	print("create zombie ........")
#	var tar_position = queue_zombie_postion.pop_back()
#	var zombie = zombie1_tscn.instance()
#	zombie.position = tar_position
#	add_child(zombie)