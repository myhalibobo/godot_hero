extends Node2D

var map_size = Vector2(160,36)
var tileSize = Vector2(64,64)
onready var tilemap = $tilemap
func _ready():
	init_path_data()

func init_path_data():
	var grid = []
	for i in range(map_size.y):
		var temp = []
		for k in range(map_size.x):
			var value = tilemap.get_cell(k,i)
			if value == -1:
				value = 1
			else:
				value = 0
			temp.append(value)
		grid.append(temp)
	path_finder_fast.init(grid,map_size.x-1,map_size.y-1)

