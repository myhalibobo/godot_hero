extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	var world_tile_map = get_node("../tilemap")
#	for row in range(160):
#		for col in range(36):
#			var pos = world_tile_map.map_to_world(Vector2(row,col))
#
#			var label = Label.new()
#			self.add_child(label)
#			label.text = "["+str(row)+","+ str(col)+"]"
#			label.rect_position = Vector2(pos.x * world_tile_map.scale.x  + label.rect_size.x/2, pos.y * world_tile_map.scale.y + 32 - label.rect_size.y/2)
#	print("")