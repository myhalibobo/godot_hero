extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
var direction = 1

func _ready():
	pass
	


func _on_timer_shoot_timeout():
	direction = randi()/3 - 1
	var path = "res://effects/blood1.tscn"
	var blood:RigidBody2D = load(path).instance()
	blood.apply_impulse(Vector2(0,0),Vector2((200 + randi()%200) * direction ,-150+randi()%150))
	
	var blood_effect_layer = get_parent()
	blood_effect_layer.add_child(blood)
	blood.position = Vector2(global_position.x + randi()%50*direction ,global_position.y+randi()%30)
	blood.gravity_scale = 10
	print("--")


