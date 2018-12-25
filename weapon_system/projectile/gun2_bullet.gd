extends KinematicBody2D

var direction_vec
var speed = 500
var speed_vec
var velocity
func _ready():
	pass # Replace with function body.

func shoot(_direction_vec):
	direction_vec = _direction_vec 

func _process(delta):
	velocity = direction_vec * speed
	move_and_slide(velocity)
	var slide_num = get_slide_count()
	if slide_num > 0:
		print("-------------->")
		queue_free()

