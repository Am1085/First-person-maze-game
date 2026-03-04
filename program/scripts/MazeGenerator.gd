extends Node3D

# Maze layout - 1 = wall, 0 = path
# 20x20 grid with complex pathways and dead ends
var maze_grid = [
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,1,1,1,1],
  [1,1,1,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1,1,1],
  [1,1,1,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1],
  [1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1],
  [1,1,1,1,1,0,1,0,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1],
  [1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
  [1,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,1],
  [1,1,1,1,1,0,0,0,0,0,0,1,1,0,1,0,0,0,0,0,0,0,0,0,1,1,1,0,1,1],
  [1,0,0,0,0,0,0,1,1,1,0,1,1,0,1,0,1,1,1,1,1,1,0,0,1,1,1,0,1,1],
  [1,1,1,1,0,1,0,1,1,1,0,1,1,0,1,0,1,1,1,1,1,1,0,0,1,1,1,0,1,1],
  [1,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,1,1,1,1,1,0,0,0,0,0,0,1,1],
  [1,1,1,1,0,1,0,1,1,0,0,0,0,0,1,0,0,0,0,0,1,1,0,1,1,1,1,1,1,1],
  [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,0,1,1,1,1,1,1,1],
  [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,0,0,0,0,1],
  [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,1],
  [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,1],
  [1,1,1,1,0,1,0,1,1,0,1,1,1,0,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1],
  [1,1,1,1,0,1,0,0,0,0,1,1,1,0,0,0,0,0,0,0,1,1,0,1,1,1,1,0,1,1],
  [1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,0,1,1,1,1,0,1,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,0,1,1],
  [1,0,1,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,0,1,1],
  [1,0,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,1],
  [1,0,1,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1],
  [1,0,1,0,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1],
  [1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
  [1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,1,1,1,1,1,1,0,1,1,0,1],
  [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,1,1,0,1],
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,1,1,0,1],
  [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
];

# Wall properties
const WALL_SIZE = 3.0
const WALL_HEIGHT = 3.0

# Materials
var wall_material: StandardMaterial3D
var wall_mesh: BoxMesh

func _ready():
	setup_materials()
	generate_maze()

func setup_materials():
	# Create wall material with better lighting response
	wall_material = StandardMaterial3D.new()
	wall_material.albedo_color = Color(0.35, 0.35, 0.45, 1.0)
	wall_material.metallic = 0.3
	wall_material.roughness = 0.7
	wall_material.specular = 0.5
	
	# Create wall mesh
	wall_mesh = BoxMesh.new()
	wall_mesh.size = Vector3(WALL_SIZE, WALL_HEIGHT, WALL_SIZE)
	wall_mesh.material = wall_material

func generate_maze():
	var rows = maze_grid.size()
	var cols = maze_grid[0].size()
	
	for i in range(rows):
		for j in range(cols):
			if maze_grid[i][j] == 1:
				create_wall(i, j)

func create_wall(row: int, col: int):
	# Create StaticBody3D for collision
	var wall_body = StaticBody3D.new()
	
	# Position: grid cell (i, j) -> 3D position (j * WALL_SIZE, WALL_HEIGHT/2, i * WALL_SIZE)
	# Y position is WALL_HEIGHT/2 so the wall sits on the ground
	var pos_x = col * WALL_SIZE
	var pos_y = WALL_HEIGHT / 2.0
	var pos_z = row * WALL_SIZE
	
	wall_body.position = Vector3(pos_x, pos_y, pos_z)
	
	# Create mesh instance
	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = wall_mesh
	wall_body.add_child(mesh_instance)
	
	# Create collision shape
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(WALL_SIZE, WALL_HEIGHT, WALL_SIZE)
	collision_shape.shape = box_shape
	wall_body.add_child(collision_shape)
	
	# Add to scene
	add_child(wall_body)
