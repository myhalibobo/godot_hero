extends "base/ranged.gd"

var bullet_node

func _ready():
	var game_scene = get_tree().get_root().get_node("game_scene")	
	bullet_node = game_scene.get_node("bullet_node")


func shoot():
	emit_bullet()
	pass

func emit_bullet():
	print("发射子弹")
	var gun2_bullet = preload("../projectile/gun2_bullet.tscn").instance()
	bullet_node.add_child(gun2_bullet)
	
	var launch_pos = get_launch_pos()
	gun2_bullet.position = launch_pos
	var direction_vec = Vector2(cos(rotation),sin(rotation))
	gun2_bullet.rotation = rotation
	gun2_bullet.shoot(direction_vec)