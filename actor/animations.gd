extends Node2D

export (NodePath) var actor_path
var actor

onready var animation_action :AnimationPlayer = $animation_action
onready var hand1 :Sprite = $hand1

signal animation_action_finished
signal animation_attack_frame

func _ready():
	actor = get_node(actor_path)

func play(name="" , custom_blend=-1, custom_speed=1.0, from_end=false):
	if animation_action.has_animation(name):
		if animation_action.current_animation != name:
			animation_action.play(name)
		elif not animation_action.is_playing():
			animation_action.play(name)
			
func stop(reset=true):
	animation_action.stop(reset)

func get_animation_hand_node():
	return hand1

func seek(name):
	pass

	
