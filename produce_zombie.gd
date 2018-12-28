extends Node2D

var zombie1_tscn
var zombie_node
var timer
var is_can_create = true
var projectResolution
var player

func _ready():
	zombie1_tscn = preload("res://actor/enemies/zombie1.tscn")
	zombie_node = get_tree().get_root().get_node("game_scene").get_node("zombie_node")
	player = get_tree().get_root().get_node("game_scene").get_node("player")
	projectResolution = get_viewport_rect().size

func _is_in_screem():
	if abs(position.x - player.position.x) > projectResolution.x / 2:
		return false
	if abs(position.y - player.position.y) > projectResolution.y / 2:
		return false
	return true
	
func _on_timer_timeout():
	if not is_can_create or not _is_in_screem():
		return
	var zombie = zombie1_tscn.instance()
	zombie.position = position
	zombie_node.add_child(zombie)
	
func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		var zombie = zombie1_tscn.instance()
		zombie.position = event.position
		zombie_node.add_child(zombie)

func _on_Arae_area_shape_entered(area_id, area, area_shape, self_shape):
	is_can_create = true



func _on_Arae_area_shape_exited(area_id, area, area_shape, self_shape):
	is_can_create = false
