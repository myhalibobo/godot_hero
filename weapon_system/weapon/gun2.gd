extends "base/ranged.gd"

var bullet_node
var osb_fire
func _ready():
	var game_scene = get_tree().get_root().get_node("game_scene")	
	bullet_node = game_scene.get_node("bullet_node")

func shoot(direction_vec,p_rotation):
	emit_bullet(direction_vec , p_rotation)
	pass

func emit_bullet(direction_vec,p_rotation):

	var gun2_bullet = preload("../projectile/gun3_bullet.tscn").instance()
	bullet_node.add_child(gun2_bullet)

	var launch_pos = get_launch_pos()
	gun2_bullet.position = launch_pos

	gun2_bullet.rotation = p_rotation
	gun2_bullet.shoot(direction_vec)