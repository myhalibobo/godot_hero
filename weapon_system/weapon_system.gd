extends Node2D
class_name WeaponSystem
enum {
	MELEE,
	RANGED,
	RANGED_TARGET
}
var weapon_map = []
var actor
var cur_weapon
var detect_info

func _ready():
	actor = get_parent()
	for weapon in get_children():
		weapon_map.append(weapon)
	cur_weapon = weapon_map[0]
	
func change_weapon():
	pass

func slash():
	cur_weapon.slash()
	pass

func shoot():
	cur_weapon.shoot()
	pass

func shoot_with_target_pos(target_pos):
	cur_weapon.shoot_with_target_pos(target_pos)

func stop(reset=true):
	cur_weapon.stop(reset)

func get_cur_weapon_type():
	return cur_weapon.type

func add_weapon():
	pass
	
func select_weapon():
	pass

func get_cur_weapon():
	return cur_weapon

func get_weapon_from_inventory():
	pass

func get_ammo_remaining_for_weapon():
	pass

func is_cur_weapon_realy():
	pass

func reaction_time():
	pass