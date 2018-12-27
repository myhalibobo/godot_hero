extends RigidBody2D

onready var timer = $timer

func _ready():
	pass # Replace with function body.

func _on_blood1_body_entered(body):
	timer.start()

func _on_timer_timeout():
	queue_free()
