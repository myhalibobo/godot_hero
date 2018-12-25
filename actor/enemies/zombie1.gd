extends "../actor.gd"

onready var ai :AiBase= $ai

func _ready():
	pass

func _process(delta):
	animations.scale.x = abs(animations.scale.x) * direction
	ai.hover_move()