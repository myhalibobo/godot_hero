extends Node2D

var zombie1_tscn
var zombie_node
onready var timer = $timer
var is_can_create = true
var projectResolution
var player
var MAX_ZEMBIE = 10

func random_range(a,b):
	return randi() % b + a
	
func _ready():
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
#	if not is_can_create or  _is_in_screem():
	if not is_can_create:
		reset_timer()
		return

	reset_timer()
	add_create_zombie_queue()

func reset_timer():
	timer.stop()
	timer.wait_time = random_range(5,10)
	timer.start()

func add_create_zombie_queue():
	zombie_node.queue_zombie_postion.append(position)
	
func _on_Arae_area_shape_entered(area_id, area, area_shape, self_shape):
	is_can_create = true


func _on_Arae_area_shape_exited(area_id, area, area_shape, self_shape):
	is_can_create = false
