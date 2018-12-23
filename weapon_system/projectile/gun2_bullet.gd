extends Area2D

var direction_vec
var speed = 1000
var speed_vec

func _ready():
	pass # Replace with function body.

func shoot(_direction_vec):
	direction_vec = _direction_vec 

func _process(delta):
	position +=  direction_vec * speed * delta
	pass

func _on_gun2_bullet_body_entered(body):
	queue_free()
