extends CharacterBody3D

# --- Variables ---
const SPEED = 5.0
const ACCEL = 20.0  # Controls how fast the player reaches max speed
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

# Get the gravity from project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# --- Initialization ---
func _ready():
	# This hides the mouse and locks it to the center of the screen
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# --- Physics Loop ---
func _physics_process(delta):
	# 1. Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Handle Jump (Optional, using Space Bar / ui_accept)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Get the input direction (W,A,S,D or Arrow Keys)
	# ui_left/right map to X, ui_up/down map to Y in Vector2
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 4. Convert input to 3D direction relative to where the player is looking
	# We use transform.basis so "Forward" is always the direction the player faces
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# 5. Apply Movement with Smoothing (move_toward)
	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL * delta)
	else:
		# Smoothly stop if no keys are pressed
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta)

	# 6. Built-in Godot function to handle collisions and movement
	move_and_slide()

# --- Input Handling (Mouse Look) ---
func _unhandled_input(event):
	# Check if the player moved the mouse
	if event is InputEventMouseMotion:
		# Rotate the whole Player body left/right (Y-axis)
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		
		# Rotate only the Camera up/down (X-axis)
		# Assuming your Camera3D is named "Camera3D"
		$Camera3D.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		
		# Clamp the vertical rotation so you can't flip your head upside down
		$Camera3D.rotation.x = clamp(
			$Camera3D.rotation.x, 
			deg_to_rad(-85), 
			deg_to_rad(85)
		)

	# ESC key to free the mouse (useful for debugging)
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
