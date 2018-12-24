extends KinematicBody2D

var direction_vec
var speed = 2000
var speed_vec
var velocity
func _ready():
	pass # Replace with function body.

func shoot(_direction_vec):
	direction_vec = _direction_vec 

func _process(delta):
	velocity = direction_vec * speed
	move_and_slide(velocity)
	pass

func _on_gun2_bullet_body_entered(body):
	queue_free()


#func _on_Area2D_body_entered(body):
#	queue_free()


func _on_area_body_entered(body):
	queue_free()
