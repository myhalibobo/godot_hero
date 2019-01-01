extends RigidBody2D

var direction_vec
var speed =2000
var speed_vec
var velocity
export (int) var hurt_value = 10
var splash_blood_effect_tscn = preload("res://effects/splash_blood_effect.tscn")
var local_collision_pos


func shoot(_direction_vec):
	direction_vec = _direction_vec
	apply_central_impulse(direction_vec * speed)

func _on_gun3_bullet_body_entered(body):
	if body.name == "tilemap":
		queue_free()
		return
	if body.name == "head_rigid":
		body.get_parent().reduce_blood(hurt_value * 4)
	elif body.name == "body_rigid": 
		body.get_parent().reduce_blood(hurt_value)
	elif body.name == "hand_rigid":
		body.get_parent().reduce_blood(hurt_value)
	else:
		body.reduce_blood(hurt_value)
	var blood_node = get_tree().get_root().get_node("game_scene").get_node("blood_node")
	var splash_blood_effect = splash_blood_effect_tscn.instance()
	blood_node.add_child(splash_blood_effect)
	splash_blood_effect.show_blood(position)
	queue_free()




