extends "../actor.gd"

onready var ai :AiBase= $ai
func _ready():
	pass

func _process(delta):
	ai.hover_move()