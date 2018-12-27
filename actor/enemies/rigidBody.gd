extends RigidBody2D

var local_collision_pos

func _ready():
	connect("body_entered",self,"_on_body_rigid_body_entered")

func _integrate_forces(state):
	if state.get_contact_count() >= 1:
		local_collision_pos = state.get_contact_local_position(0)

func _on_body_rigid_body_entered(body):
	if body.name != "head_rigid" and body.name != "body_rigid" and body.name != "hand_rigid" and body.name != "zombie1" and body.name != "tilemap":
		get_parent().get_node("blood_effect").show_blood(local_collision_pos)
