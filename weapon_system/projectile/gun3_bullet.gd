extends RigidBody2D

var direction_vec
var speed = 2000
var speed_vec
var velocity
export (int) var hurt_value = 10
func _ready():
	pass # Replace with function body.

func shoot(_direction_vec):
	direction_vec = _direction_vec
	apply_central_impulse(direction_vec * speed)
	

func _on_gun3_bullet_body_entered(body):
	if body.name == "head_body":
		body.get_parent().reduce_body(hurt_value * 4)
	else:
		body.reduce_blood(hurt_value)
	queue_free()




