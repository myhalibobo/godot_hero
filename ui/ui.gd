extends CanvasLayer

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var hp_bar :TextureProgress= $hp_bar
func _ready():
	pass
	
func _process(delta):
	var frame = Engine.get_frames_per_second()
	$fps.text = str(frame)


func _on_player_hp_change(value):
	hp_bar.value = value
