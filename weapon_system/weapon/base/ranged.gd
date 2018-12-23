extends "weapon.gd"
onready var shoot_position = $shoot_position

func _ready():
	pass

func get_launch_pos():
	return shoot_position.global_position