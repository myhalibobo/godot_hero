extends CanvasLayer

var zombie_num = 0
onready var monster_num = $monster_num
onready var hp_bar :TextureProgress= $hp_bar
func _ready():
	pass
	
func _process(delta):
	var frame = Engine.get_frames_per_second()
	$fps.text = str(frame)


func hp_change(value):
	hp_bar.value = value

func set_zombie_num(v):
	zombie_num += v
	monster_num.text = str(zombie_num)