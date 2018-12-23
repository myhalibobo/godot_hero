extends Node2D

export (NodePath) var actor_path
var actor

onready var animation_action :AnimationPlayer = $animation_action
onready var hand1 :Sprite = $hand1

signal animation_action_finished
signal animation_attack_frame

func _ready():
	actor = get_node(actor_path)
	animation_action.connect("animation_finished",self,"_on_animation_action_animation_finished")

func play(name="" , custom_blend=-1, custom_speed=1.0, from_end=false):
	if animation_action.has_animation(name):
		if animation_action.current_animation != name:
			animation_action.play(name)
		elif not animation_action.is_playing():
			animation_action.play(name)

#func play_hurt_effect(attack_body):
#	if not animation_hurt_color.is_playing():
#		if particals_blood:
#			particals_blood.emitting = true
#			if attack_body.position.x > actor.position.x:
#				particals_blood.scale.x = 1
#				animation_blood.flip_h = false
#				animation_blood.position = Vector2(abs(animation_blood.position.x),animation_blood.position.y)
#			else:
#				particals_blood.scale.x = -1
#				animation_blood.flip_h = true
#				animation_blood.position = Vector2(-abs(animation_blood.position.x),animation_blood.position.y)				
#		animation_hurt_color.play("hurt_effect")

func stop(reset=true):
	animation_action.stop(reset)

func get_animation_hand_node():
	return hand1

func seek(name):
	pass

#func _on_attack_frame(index,is_only_clear_colision):
#	emit_signal("animation_attack_frame",index,is_only_clear_colision)
#
#func _process(delta):
#	animation_body.direction_changed(actor.direction,actor)
#
#func _on_animation_action_animation_finished(anim_name):
#	emit_signal("animation_action_finished",anim_name)
	
