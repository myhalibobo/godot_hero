extends "../actor.gd"

var hand:Sprite
var cur_weapon
var gun_direction_vec
var is_flap_x = true
var emit_direction = 1
var ui
onready var weapon_system :WeaponSystem = $weapon_system


func _ready():
	HP = 100
	hand = animations.get_animation_hand_node()
	cur_weapon = weapon_system.get_cur_weapon()
	ui = get_tree().get_root().get_node("game_scene").get_node("ui")
#	world_tile_map = get_tree().get_root().get_node("game_scene").get_node("tilemap")
	
func _input(event):
	if event is InputEventMouse:
		var local_event = make_input_local(event)

		var mouse_postion = local_event.position
		
		var angle = mouse_postion.angle_to_point(hand.position*animations.scale.x)
		
		hand.rotation = angle

		if angle > -PI/2 and angle < PI/2:
#			scale.x = abs(scale.x) * 1 
			pass
		else:
			emit_direction = emit_direction *-1
			scale.x = abs(scale.x) * -1 

func _process(delta):
	cur_weapon.rotation = hand.rotation
	if HP == 0:
		set_process(false)
		set_process_input(false)
		ui.add_child(preload("res://game_end.tscn").instance())
		ui.kill_num_str = "0"
	
func reduce_blood(value):
	.reduce_blood(value)
	ui.hp_change(HP)

	