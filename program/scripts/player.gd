extends CharacterBody3D

const SPEED = 5.0
const ACCEL = 20.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.002

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var game_over = false

@onready var footsteps = $Footsteps

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	footsteps.stop()  # Ensure sound is explicitly off at start

func _physics_process(delta):
	if game_over:
		footsteps.stop()
		return

	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCEL * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, ACCEL * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		velocity.z = move_toward(velocity.z, 0, ACCEL * delta)

	move_and_slide()

	# Footsteps: MUST be after move_and_slide() and check ACTUAL velocity
	var horizontal_speed = Vector2(velocity.x, velocity.z).length()
	var is_moving = horizontal_speed > 0.5  # Raised threshold to prevent false triggers

	if is_on_floor() and is_moving:
		if not footsteps.playing:
			footsteps.play()
	else:
		if footsteps.playing:
			footsteps.stop()

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)
		$Camera3D.rotate_x(-event.relative.y * MOUSE_SENSITIVITY)
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x, deg_to_rad(-85), deg_to_rad(85))

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
