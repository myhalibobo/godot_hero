extends Node
class_name DetectInfo
var actor
var nor_wander
var rayc_floor_left
var rayc_floor_right
var rayc_wall_left
var rayc_wall_right

var rayc_check_enemy
var area2d_attack_range
var area2d_see

var attacked_body
var is_into_attact_range

var see_radius

export (float) var attack_distance = 140
export (float) var detect_distance = 140
export (float) var rayc_check_retreat_len = 200


func _ready():
	actor = get_parent()
	if has_node("nor_wander"):
		nor_wander = $nor_wander
		rayc_floor_left = $nor_wander/rayc_floor_left
		rayc_wall_left = $nor_wander/rayc_wall_left
		rayc_floor_right = $nor_wander/rayc_floor_right
		rayc_wall_right = $nor_wander/rayc_wall_right

	if has_node("area2d_see"):
		area2d_see = $area2d_see
		area2d_see.connect("body_entered",self,"_on_area2d_see_body_entered")
		area2d_see.connect("body_exited", self, "_on_area2d_see_body_exited")
		see_radius = area2d_see.get_node("CollisionShape2D").shape.radius
		
	if has_node("rayc_check_enemy"):
		rayc_check_enemy = $rayc_check_enemy
	


func is_left_down_is_air():
	if rayc_floor_left and not rayc_floor_left.is_colliding():
		return true
	else:
		return false
			
func is_left_collision_obstacles():
	if rayc_wall_left and rayc_wall_left.is_colliding():
		return true
	else:
		return false
		
func is_rignt_down_is_air():
	if rayc_floor_right and not rayc_floor_right.is_colliding():
		return true
	else:
		return false
		
func is_right_collision_obstacles():
	if rayc_wall_right and rayc_wall_right.is_colliding():
		return true
	else:
		return false

func is_face_to_enemy():
	var vec = Vector2(1*actor.direction,0)
	var vec2 = attacked_body.position - actor.position
	var dot = vec.x * vec2.x + vec.y * vec.y
	if dot > 0:
		return true
	return false

func is_see_enemy_not_obstructe():
	if not attacked_body:
		return false
	if not is_face_to_enemy():
		return false
	
	if detect_with_direction(actor.direction):
		return true
	return false

func detect_with_direction(direction):
	rayc_check_enemy.cast_to = Vector2(see_radius * direction , 0)
	rayc_check_enemy.force_raycast_update()
	if rayc_check_enemy.is_colliding():
		var collider = rayc_check_enemy.get_collider()
		if collider.name == "player":
			return true
	return false

func is_into_attack_range():
	if not attacked_body:
		return false
	var distance_x = abs(actor.position.x - attacked_body.position.x)
	if distance_x <= attack_distance * actor.scale.x:
		return true
	else:
		return false

func get_attecked_body():
	return attacked_body

func _on_area2d_attack_range_body_entered(body):
	attacked_body = body
	is_into_attact_range = true
	
func _on_area2d_attack_range_body_exited(body):
	is_into_attact_range = false

func _on_area2d_see_body_entered(body):
	attacked_body = body
	
func _on_area2d_see_body_exited(body):
	attacked_body = null

