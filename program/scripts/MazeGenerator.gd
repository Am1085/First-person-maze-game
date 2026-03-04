extends Node3D

@export var wall_scene: PackedScene

# 1 = Wall
# 0 = Empty space
var maze_grid = [
	[1,1,1,1,1],
	[1,0,0,0,1],
	[1,0,1,0,1],
	[1,0,0,0,1],
	[1,1,1,1,1]
]

var cell_size = 3.0   # Must match wall width

func _ready():
	generate_maze()

func generate_maze():
	for row in range(maze_grid.size()):
		for col in range(maze_grid[row].size()):
			
			if maze_grid[row][col] == 1:
				var wall = wall_scene.instantiate()
				
				# Column → X axis
				# Row → Z axis
				wall.position = Vector3(
					col * cell_size,
					1.5,
					row * cell_size
				)
				
				add_child(wall)
