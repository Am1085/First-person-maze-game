extends CharacterBody3D

const SPEED = 5.0
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# 1. Apply Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# 2. Get Input (Local Space)
	# Returns a vector like (1, 0) for Right or (-1, 0) for Left
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	# 3. Transform Local Input to Global Direction
	# We use 'transform.basis' so "Forward" is relative to where we are looking
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# 4. Apply Velocity
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * 0.002)
		$Camera3D.rotate_x(-event.relative.y * 0.002)
		$Camera3D.rotation.x = clamp(
			$Camera3D.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)