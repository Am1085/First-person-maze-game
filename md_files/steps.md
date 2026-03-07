**step 1**
Pre-Production & Maze Planning
Owner: Shakshi (Lead), All (Support)

Theory: The Discrete vs. Continuous World
Computers represent mazes logically as a Discrete Grid (integers), but render them in a Continuous Space (floats).

Concept: A 2D array maze[row][col] where row maps to the Z-axis and col maps to the X-axis.

Implementation Task:
Design a 30x30 grid on paper.

Mark 1 for Walls and 0 for Paths.

Identify the Start Point (e.g., [1, 1]) and End Point (e.g., [28, 30]).


MazeGenerator.md file banau la till sunday rati 
Github bata program folder pull garera file lekhne ani different branch ma MazeGenerator.md file push garne la   dive how its done if any issue arises
lets choose the actual way professionals do 

**step 2**
Godot Project Setup
Owner: Amrita

Step-by-Step Implementation:
Create Project: New Project -> Select "Forward+" Renderer (High-end graphics features).

Root Scene: Create a 3D Scene. Name the root node Main.

Folder Structure:

res://Scenes/ (for .tscn files)

res://Scripts/ (for .gd files)

res://Assets/ (for materials/meshes)

**step 3**
Prajwal (The Physics Controller)
Goal: Create a CharacterBody3D that obeys physics and input.

Step 1: Create the Player Scene

In Godot, click Scene → New Scene.

Select CharacterBody3D as the root node. Rename it Player.

Add a CollisionShape3D as a child.

Inspector: Set Shape to CapsuleShape3D.

Transform: Ensure it is centered.

Add a Camera3D as a child.

Transform: Set Position y to 1.6 (this places the "eyes" near the top of the capsule).

Step 2: The Movement Script
Use Input.get_vector("left", "right", "up", "down") to get raw 2D input.
Transform Logic: Convert local input (W = Forward) to global coordinates using transform.basis.
Direction = Basis \times (Input_x, 0, Input_y)$.
write the wasd logic for control

program/scripts/player.md

**step 4**
Owner: Amrita
Goal: Create reusable environment building blocks.

Tasks (Missing but REQUIRED):
1️⃣ Create Wall Blueprint
res://Models/Wall.tscn

Steps:

Root: StaticBody3D

Child: MeshInstance3D

Mesh: BoxMesh

Child: CollisionShape3D

Shape: BoxShape3D

Transform: Wall centered at (0,0,0)

📌 Viva Concept: Local vs World Space

Keeping mesh centered allows easy placement using coordinates later.

2️⃣ Create Floor (CRITICAL)
res://Models/Floor.tscn

StaticBody3D

BoxMesh (large flat)

CollisionShape3D

⚠️ Why this was missing:
Without a floor → Player falls forever → physics broken.

3️⃣ World Lighting

Add DirectionalLight3D (Sun)

Optional: WorldEnvironment (basic exposure)

**step 5**
 Owner: Shakshi

This is the academic core of the project.

1️⃣ MazeGenerator.gd (NOT .md)

📁 res://Scripts/MazeGenerator.gd

Responsibilities:

Own the maze matrix

Convert discrete data → continuous 3D space

@export var wall_scene: PackedScene

var maze_grid = [
	[1,1,1,1,1],
	[1,0,0,0,1],
	[1,0,1,0,1],
	[1,0,0,0,1],
	[1,1,1,1,1]
]

func _ready():
	for row in maze_grid.size():
		for col in maze_grid[row].size():
			if maze_grid[row][col] == 1:
				var wall = wall_scene.instantiate()
				wall.position = Vector3(col * 3, 1.5, row * 3)
				add_child(wall)

📌 Viva Gold Point

Row → Z axis

Column → X axis

Grid → World Mapping

Scaling factor = wall width

2️⃣ Maze.tscn

📁 res://Scenes/Maze.tscn

Root: Node3D

Attach MazeGenerator.gd

Assign Wall.tscn in Inspector

🚫 No player here
🚫 No camera here

**step 6**
Owner: Prajwal
Already have:
✔ CharacterBody3D
✔ Capsule collision
✔ Camera
✔ WASD movement

🔧 Add Mouse Look (Missing)
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.002)
		$Camera3D.rotate_x(-event.relative.y * 0.002)
		$Camera3D.rotation.x = clamp(
			$Camera3D.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

📌 Viva Concept

Yaw → Player

Pitch → Camera

Euler angles & Gimbal Lock

**step 7**
THE BRIDGE 

Owner: Prajwal

This phase connects everything.
Until now, all scenes exist in isolation.
Now we assemble the actual game world.

🎯 Purpose of Main.tscn

Single orchestration point

Zero logic

Zero movement code

Only composition

📌 Viva Line

“Main.tscn acts as the scene graph root that composes independent systems into a playable world.”

📁 File
res://Scenes/Main.tscn
🌳 Node Tree (Exact)
Main (Node3D)
├── Maze (instance of Maze.tscn)
├── Player (instance of Player.tscn)
├── Floor (instance of Floor.tscn)
├── DirectionalLight3D
└── WorldEnvironment (optional but recommended)
🛠️ Step-by-Step Creation
1️⃣ Create Main Scene

Scene → New Scene

Root Node: Node3D

Rename to Main

Save as Main.tscn

2️⃣ Instance Maze

Click Main

Instance Maze.tscn

Rename node to Maze

📌 Maze already spawns walls internally via MazeGenerator.gd

3️⃣ Instance Player

Instance Player.tscn

Rename node to Player

Set position:

X = 3
Y = 2
Z = 3

📌 Spawn slightly above ground to avoid collision jitter

4️⃣ Instance Floor

Instance Floor.tscn

Ensure:

Y = 0
Scale = Large enough to cover maze
5️⃣ Add Sun Light

Add DirectionalLight3D

Rotation:

X = -45°
Y = 30°

📌 Simulates sunlight

6️⃣ (Optional) WorldEnvironment

Add WorldEnvironment

Environment:

Exposure enabled

Slight ambient light

🔒 Golden Rule Applied

✔ Maze.tscn → only Shakshi
✔ Player.tscn → only Prajwal
✔ Visual tweaks → Amrita
✔ Main.tscn → composition only

💥 Zero merge conflicts

**step 8**
VISUAL QUALITY
Owner: Amrita

This phase converts “blocks” → “game environment”

🧱 Wall PBR Material (Deep Detail)
Where

Wall.tscn

Select MeshInstance3D

Material → StandardMaterial3D

Settings (Explainable in Viva)
Property	Value	Reason
Albedo	Gray / Brick	Base color
Roughness	0.8	Diffuse walls
Metallic	0.0	Concrete ≠ metal
Normal Map	Optional	Surface detail

📌 Viva Definition

PBR models how light physically interacts with surfaces using real-world parameters.

🔦 Flashlight System (Critical)
Node Placement
Player
└── Camera3D
    └── SpotLight3D
SpotLight3D Settings
Property	Value
Range	15
Spot Angle	40°
Intensity	3.0
Shadows	Enabled

📌 Light moves with camera → true flashlight

🎓 Viva Question You’ll Get

Q: Why attach light to camera?
A:

Because camera rotation defines player view direction, ensuring light direction matches visual perception.

**step 9**
🟩 EXIT GOAL SYSTEM

Owner: Amrita

📁 File
res://Models/Goal.tscn
Node Structure
Goal (Area3D)
├── CollisionShape3D
└── MeshInstance3D
Setup

Mesh: Cylinder / Cube

Color: Bright Green / Gold

Collision: Enabled

Monitoring: ON

📌 Area3D is used because it detects overlap without blocking movement

Place Goal

Instance Goal.tscn into Main.tscn

Position at maze exit

**step 10**
🧠 WIN CONDITION LOGIC

Owner: Prajwal

In Player.gd
Signal Connection

Select Goal

Signals → body_entered

Connect to Player

Code
func _on_goal_body_entered(body):
	if body.name == "Player":
		print("You Win!")

**step 11**
owner: Shakshi

draw a minimap on top right cornor of the game 
which shows only when user asks for help by pressing "H" 
use player dot for the positioning too






STEP 10 — Game Timer

Shows how long the player takes to finish the maze.

1. Add Timer Label

In your scene tree:

Main
└── UI
    ├── Winmessage
    └── TimerLabel

Create Label → rename to TimerLabel

Inspector:

Text = Time: 0
Layout → Top Left
Font Size = 30
2. Add Script to Main

Attach a script to main node.

extends Node3D

var time_elapsed = 0.0
@onready var timer_label = $UI/TimerLabel

func _process(delta):
	time_elapsed += delta
	timer_label.text = "Time: " + str(int(time_elapsed))

Now the timer counts during gameplay.

STEP 11 — Stop Player When Maze Is Completed

Open your Goal script and modify it.

Goal (Area3D)

Script:

extends Area3D

func _on_body_entered(body):
	if body.name == "Player":
		var label = get_tree().current_scene.get_node("UI/Winmessage")
		label.visible = true
		
		body.set_physics_process(false)

Result:

Player reaches exit
→ Message appears
→ Player movement stops
STEP 12 — Restart Game Button

Update Winmessage text:

🎉 MAZE COMPLETED 🎉
Press R to Restart

Add this inside main script:

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()

Now pressing Enter restarts the maze.

STEP 13 — Background Music

Add node:

Main
└── Music (AudioStreamPlayer)

Inspector:

Stream → add music file
Autoplay = ON
Volume = -10

Recommended sound: dark ambient maze music.

STEP 14 — Footstep Sound

Inside Player

Player
└── Footsteps (AudioStreamPlayer3D)

Then in player.gd:

if velocity.length() > 0:
	if !$Footsteps.playing:
		$Footsteps.play()

Now the player makes walking sounds.

STEP 15 — Add Sky Environment

Add node:

Main
└── WorldEnvironment

Inspector:

Environment → New Environment
Background → Sky
Sky → New ProceduralSkyMaterial

Now the maze has natural sky lighting.

STEP 16 — Add Fog (Atmosphere)

Inside Environment settings:

Fog → Enabled
Density → 0.02
Color → Dark blue

Now the maze feels mysterious and deeper.

STEP 17 — Improve Flashlight

Your flashlight color is currently pink.

Change in SpotLight3D:

Light Color = (1, 0.95, 0.8)
Energy = 4
Range = 20

This looks like a real flashlight.

STEP 18 — Better Win Message

Select Winmessage

Change:

Text = 🎉 MAZE COMPLETED 🎉

Add color:

Font Color = Green
Font Size = 70

Center it.

STEP 19 — Player Icon on Minimap

Inside Player

Add:

Sprite3D

Use a red circle texture.

Now on the minimap you see your player position moving.