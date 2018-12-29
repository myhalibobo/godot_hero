extends Node2D

var zombie1_tscn
var zombie_node
onready var timer = $timer
var is_can_create = true
var projectResolution
var player

func random_range(a,b):
	return randi() % b + a
	
func _ready():
	zombie1_tscn = preload("res://actor/enemies/zombie1.tscn")
	zombie_node = get_tree().get_root().get_node("game_scene").get_node("zombie_node")
	player = get_tree().get_root().get_node("game_scene").get_node("player")
	projectResolution = get_viewport_rect().size
	timer.wait_time = float(random_range(4,10))
	timer.start()

func _is_in_screem():
	if abs(position.x - player.position.x) > projectResolution.x / 2:
		return false
	if abs(position.y - player.position.y) > projectResolution.y / 2:
		return false
	return true
	
func _on_timer_timeout():
	if not is_can_create or  _is_in_screem():
		timer.wait_time = random_range(4,10)
		return
	timer.wait_time = random_range(4,10)
	timer.start()
#	var zombie = zombie1_tscn.instance()
#	zombie.position = position
#	zombie_node.add_child(zombie)
	

func _on_Arae_area_shape_entered(area_id, area, area_shape, self_shape):
	is_can_create = true


func _on_Arae_area_shape_exited(area_id, area, area_shape, self_shape):
	is_can_create = false
