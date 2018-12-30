extends CanvasLayer

var zombie_num = 0
onready var monster_num = $monster_num
onready var hp_bar :TextureProgress= $hp_bar
onready var kill_num_str = $kill_num
var kill_num = 0
func _ready():
	pass
	
func _process(delta):
	var frame = Engine.get_frames_per_second()
	$fps.text = str(frame)


func hp_change(value):
	hp_bar.value = value

func set_zombie_num(v):
	zombie_num = v
	monster_num.text = str(zombie_num)

func add_kill_num():
	kill_num+=1
	kill_num_str.text = str(kill_num)