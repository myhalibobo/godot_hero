extends "../actor.gd"

var hand:Sprite
var cur_weapon
var gun_direction_vec

func _ready():
	hand = animations.get_animation_hand_node()
	cur_weapon = weapon_system.get_cur_weapon()
	print(cur_weapon)
	
func _input(event):
	if event is InputEventMouse:
		var mouse_postion = event.global_position
		var angle = mouse_postion.angle_to_point(hand.global_position)
		hand.rotation = angle
#		if angle > -PI/2 and angle < PI/2:
#			scale.x = abs(scale.x) * 1 
#		else:
#			scale.x = abs(scale.x) * -1 
	pass

func _process(delta):
	cur_weapon.rotation = hand.rotation
	