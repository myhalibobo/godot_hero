extends RigidBody2D

var speed = 500
var direction

func _ready():
	friction = 1
	pass # Replace with function body.
	
func _process(delta):
	if Input.is_action_just_pressed("LEFT"):
		apply_central_impulse(Vector2(-speed,0))
	elif Input.is_action_just_pressed("RIGHT"):
		apply_central_impulse(Vector2(speed,0))
	
	